from __future__ import annotations

import json
from datetime import date, datetime, time, timedelta

from flask import Blueprint, g, jsonify, request
from sqlalchemy import or_

from . import BusinessError
from .extensions import db
from .models import (
    Activity,
    ActivityComment,
    ActivityParticipant,
    Attendance,
    ClassInfo,
    Contact,
    Conversation,
    Evaluation,
    GradeReport,
    HealthRecord,
    Homework,
    Message,
    Notice,
    Participant,
    School,
    Submission,
    User,
)
from .security import generate_token, hash_password, login_required, verify_password

api_bp = Blueprint("api", __name__)


def ok(data=None):
    return jsonify({"code": 0, "message": "success", "data": data})


def page_result(query, page: int, page_size: int, serializer=lambda item: item.to_dict()):
    page = max(page, 1)
    page_size = min(max(page_size, 1), 100)
    pagination = query.paginate(page=page, per_page=page_size, error_out=False)
    items = [serializer(item) for item in pagination.items]
    return {
        "list": items,
        "records": items,
        "total": pagination.total,
        "page": page,
        "pageSize": page_size,
    }


def visible_student_ids(user: User | None) -> list[int] | None:
    if not user:
        return []
    role = str(user.role).upper()
    if role in ("TEACHER", "LEADER"):
        return None
    if role == "STUDENT":
        return [int(user.id)]
    if role == "PARENT":
        try:
            return [int(item) for item in json.loads(user.child_ids or "[]")]
        except (TypeError, ValueError, json.JSONDecodeError):
            return []
    return []


def homework_payload(homework: Homework) -> dict:
    data = homework.to_dict()
    due = homework.due_date
    data["status"] = "expired" if due and due < datetime.utcnow() else (homework.status or "active")
    return data


def conversation_payload(conversation: Conversation) -> dict:
    data = conversation.to_dict()
    participants = Participant.query.filter_by(conversation_id=conversation.id).all()
    data["participants"] = [item.to_dict() for item in participants]
    # Override with per-user unread count
    current = next((item for item in participants if item.user_id == g.user_id), None)
    data["unreadCount"] = current.unread_count if current else 0
    if conversation.type == "private":
        other = next((item for item in participants if item.user_id != g.user_id), None)
        if other:
            data["name"] = other.user_name
            data["avatar"] = other.avatar
    return data


def body() -> dict:
    return request.get_json(silent=True) or {}


def parse_dt(value):
    if not value:
        return None
    if isinstance(value, datetime):
        return value
    if isinstance(value, date):
        return datetime.combine(value, time.min)
    if isinstance(value, (int, float)) or (isinstance(value, str) and value.strip().isdigit()):
        try:
            number = float(value)
            if number > 10_000_000_000:
                number = number / 1000
            return datetime.fromtimestamp(number)
        except (TypeError, ValueError, OSError):
            return None
    normalized = str(value).replace("Z", "+00:00")
    try:
        parsed = datetime.fromisoformat(normalized)
        return parsed.replace(tzinfo=None) if parsed.tzinfo else parsed
    except ValueError:
        return None


def parse_date(value):
    parsed = parse_dt(value)
    return parsed.date() if parsed else None


def parse_time(value):
    if not value:
        return None
    if isinstance(value, time):
        return value
    parsed = parse_dt(value)
    if parsed:
        return parsed.time().replace(microsecond=0)
    try:
        return time.fromisoformat(str(value))
    except ValueError:
        return None


def parse_int_id(value, field: str = "id") -> int:
    raw = str(value or "").strip()
    if not raw or not raw.isdigit() or len(raw) > 18:
        raise BusinessError(f"Invalid {field}")
    return int(raw)


def scoped_student_query(current: User):
    role = str(current.role).upper()
    query = User.query.filter(User.role.in_(["student", "STUDENT"]))
    if role in ("TEACHER", "LEADER"):
        if current.school_id:
            query = query.filter(User.school_id == current.school_id)
    else:
        allowed = visible_student_ids(current) or []
        query = query.filter(User.id.in_(allowed or [0]))
    class_id = request.args.get("classId", type=int)
    if class_id:
        query = query.filter(User.class_id == class_id)
    return query


def assert_visible_student(current: User, student_id: int) -> User:
    student = scoped_student_query(current).filter(User.id == student_id).first()
    if not student:
        raise BusinessError("No permission to access this student", code=403, http_status=403)
    return student


def json_text(value, default="[]"):
    if value is None:
        return default
    if isinstance(value, str):
        return value
    return json.dumps(value, ensure_ascii=False)


def get_or_404(model, item_id: int, message: str):
    item = db.session.get(model, item_id)
    if not item:
        raise BusinessError(message)
    return item


@api_bp.get("/")
def root():
    return ok({"name": "Hwadee FSC Flask Backend", "status": "running"})


@api_bp.get("/doc.html")
def docs():
    return ok({"message": "Flask backend is running. API paths are compatible with the HarmonyOS client."})


@api_bp.post("/api/auth/login")
def login():
    payload = body()
    account = (payload.get("account") or payload.get("email") or payload.get("phone") or "").strip()
    if not account:
        raise BusinessError("Phone or email is required", code=1001)
    user = User.query.filter(or_(User.phone == account, User.email == account)).first()
    if not user or not verify_password(payload.get("password", ""), user.password):
        raise BusinessError("Invalid account or password", code=1001)
    return ok({"user": user.to_dict(), "token": generate_token(user.id, user.role)})


@api_bp.post("/api/auth/register")
def register():
    payload = body()
    required = ["name", "password", "role"]
    if any(not payload.get(field) for field in required):
        raise BusinessError("Name, password and role are required")
    phone = (payload.get("phone") or "").strip()
    email = (payload.get("email") or "").strip()
    if not phone and not email:
        raise BusinessError("Phone or email is required")
    if phone and User.query.filter_by(phone=phone).first():
        raise BusinessError("Phone is already registered")
    if email and User.query.filter_by(email=email).first():
        raise BusinessError("Email is already registered")
    school_id = payload.get("schoolId")
    school_name = ""
    if school_id:
        school = db.session.get(School, int(school_id))
        if school:
            school_name = school.name
    class_id = payload.get("classId")
    class_name = payload.get("className") or ""
    grade = 0
    if class_id:
        class_info = db.session.get(ClassInfo, int(class_id))
        if class_info:
            class_name = class_info.name
            grade = class_info.grade or 0
            if not school_id:
                school_id = class_info.school_id
            if not school_name and class_info.school_id:
                school = db.session.get(School, int(class_info.school_id))
                school_name = school.name if school else ""
    user = User(
        name=payload["name"],
        phone=phone or None,
        email=email or None,
        password=hash_password(payload["password"]),
        role=payload["role"],
        school_id=school_id,
        school_name=school_name,
        class_id=class_id,
        class_name=class_name,
        grade=grade,
    )
    db.session.add(user)
    db.session.commit()
    return ok(user.to_dict())

@api_bp.post("/api/auth/logout")
def logout():
    return ok(None)


@api_bp.get("/api/notices")
def notices():
    query = Notice.query
    if request.args.get("type"):
        query = query.filter(Notice.type == request.args["type"])
    if request.args.get("keyword"):
        keyword = f"%{request.args['keyword']}%"
        query = query.filter((Notice.title.like(keyword)) | (Notice.summary.like(keyword)))
    query = query.order_by(Notice.is_top.desc(), Notice.created_at.desc())
    return ok(page_result(query, int(request.args.get("page", 1)), int(request.args.get("pageSize", 20))))


@api_bp.get("/api/notices/<int:notice_id>")
def notice_detail(notice_id: int):
    notice = get_or_404(Notice, notice_id, "通知不存在")
    notice.view_count = (notice.view_count or 0) + 1
    db.session.commit()
    return ok(notice.to_dict())


@api_bp.post("/api/notices")
@login_required
def notice_create():
    payload = body()
    user = db.session.get(User, g.user_id)
    notice = Notice(
        title=payload.get("title", ""),
        summary=payload.get("summary", ""),
        content=payload.get("content"),
        type=payload.get("type", "notification"),
        publisher_id=g.user_id,
        publisher_name=user.name if user else "",
        publisher_avatar=user.avatar if user else "",
        scope=payload.get("scope", "all"),
        scope_target_id=payload.get("scopeTargetId"),
        attachments=json_text(payload.get("attachments")),
        is_top=bool(payload.get("isTop", False)),
    )
    db.session.add(notice)
    db.session.commit()
    return ok(notice.to_dict())


@api_bp.put("/api/notices/<int:notice_id>")
@login_required
def notice_update(notice_id: int):
    notice = get_or_404(Notice, notice_id, "通知不存在")
    payload = body()
    for api_key, attr in {"title": "title", "summary": "summary", "content": "content", "type": "type", "scope": "scope"}.items():
        if api_key in payload:
            setattr(notice, attr, payload[api_key])
    if "isTop" in payload:
        notice.is_top = bool(payload["isTop"])
    if "attachments" in payload:
        notice.attachments = json_text(payload["attachments"])
    notice.updated_at = datetime.utcnow()
    db.session.commit()
    return ok(notice.to_dict())


@api_bp.delete("/api/notices/<int:notice_id>")
@login_required
def notice_delete(notice_id: int):
    notice = get_or_404(Notice, notice_id, "通知不存在")
    db.session.delete(notice)
    db.session.commit()
    return ok(None)


@api_bp.get("/api/homework")
def homework_list():
    query = Homework.query
    if request.args.get("classId"):
        query = query.filter(Homework.class_id == request.args.get("classId", type=int))
    status = request.args.get("status")
    if status in ("active", "expired"):
        now = datetime.utcnow()
        if status == "expired":
            query = query.filter(Homework.due_date.isnot(None), Homework.due_date < now)
        else:
            query = query.filter(or_(Homework.due_date.is_(None), Homework.due_date >= now))
    query = query.order_by(Homework.assigned_at.desc())
    return ok(page_result(query, int(request.args.get("page", 1)), int(request.args.get("pageSize", 20)), homework_payload))


@api_bp.get("/api/homework/<int:homework_id>")
def homework_detail(homework_id: int):
    return ok(get_or_404(Homework, homework_id, "作业不存在").to_dict())


@api_bp.post("/api/homework")
@login_required
def homework_create():
    payload = body()
    user = db.session.get(User, g.user_id)
    homework = Homework(
        subject=payload.get("subject", ""),
        title=payload.get("title", ""),
        content=payload.get("content"),
        teacher_id=g.user_id,
        teacher_name=user.name if user else "",
        class_id=payload.get("classId"),
        class_name=payload.get("className", ""),
        due_date=parse_dt(payload.get("dueDate")),
        attachments=json_text(payload.get("attachments")),
        total_students=payload.get("totalStudents") or 0,
        status="active",
    )
    db.session.add(homework)
    db.session.commit()
    return ok(homework.to_dict())


@api_bp.get("/api/homework/<int:homework_id>/submission")
@login_required
def homework_submission(homework_id: int):
    user = db.session.get(User, g.user_id)
    is_staff = user is not None and str(user.role).upper() in ("TEACHER", "LEADER")
    requested = request.args.get("studentId", type=int)
    student_id = requested if (requested and is_staff) else g.user_id
    submission = Submission.query.filter_by(homework_id=homework_id, student_id=student_id).first()
    if not submission:
        raise BusinessError("未找到提交记录")
    return ok(submission.to_dict())


@api_bp.post("/api/homework/<int:homework_id>/submission")
@login_required
def homework_submit(homework_id: int):
    get_or_404(Homework, homework_id, "作业不存在")
    payload = body()
    student = db.session.get(User, g.user_id)
    submission = Submission.query.filter_by(homework_id=homework_id, student_id=g.user_id).first()
    created = submission is None
    if created:
        submission = Submission(homework_id=homework_id, student_id=g.user_id)
        db.session.add(submission)
    submission.student_name = student.name if student else ""
    submission.student_avatar = student.avatar if student else ""
    submission.content = payload.get("content")
    submission.attachments = json_text(payload.get("attachments"))
    submission.status = "submitted"
    submission.submitted_at = datetime.utcnow()
    if created:
        homework = db.session.get(Homework, homework_id)
        homework.submission_count = (homework.submission_count or 0) + 1
    db.session.commit()
    return ok(submission.to_dict())


@api_bp.put("/api/submissions/<int:submission_id>/grade")
@login_required
def submission_grade(submission_id: int):
    submission = get_or_404(Submission, submission_id, "提交记录不存在")
    payload = body()
    score = payload.get("score", request.args.get("score", type=int))
    submission.score = int(score) if score is not None else None
    submission.teacher_comment = payload.get("comment", request.args.get("comment", ""))
    submission.status = "graded"
    db.session.commit()
    return ok(submission.to_dict())


@api_bp.get("/api/conversations")
@login_required
def conversations():
    ids = [p.conversation_id for p in Participant.query.filter_by(user_id=g.user_id).all()]
    if not ids:
        return ok([])
    rows = Conversation.query.filter(Conversation.id.in_(ids)).order_by(Conversation.updated_at.desc()).all()
    return ok([conversation_payload(row) for row in rows])


@api_bp.post("/api/conversations")
@login_required
def conversation_create():
    payload = body()
    target_user_id = int(payload.get("targetUserId") or payload.get("target_user_id") or 0)
    if not target_user_id:
        raise BusinessError("请选择联系人")
    if target_user_id == g.user_id:
        raise BusinessError("不能和自己发起会话")

    target = get_or_404(User, target_user_id, "联系人不存在")
    current = get_or_404(User, g.user_id, "用户不存在")
    current_ids = {
        item.conversation_id for item in Participant.query.filter_by(user_id=g.user_id).all()
    }
    target_ids = {
        item.conversation_id for item in Participant.query.filter_by(user_id=target_user_id).all()
    }
    existing_participant = None
    for conversation_id in current_ids.intersection(target_ids):
        row = Conversation.query.filter_by(id=conversation_id, type="private").first()
        if not row:
            continue
        participants = Participant.query.filter_by(conversation_id=conversation_id).all()
        participant_ids: set[int] = set()
        for item in participants:
            try:
                participant_ids.add(int(item.user_id))
            except (TypeError, ValueError):
                continue
        if participant_ids == {int(g.user_id), target_user_id}:
            existing_participant = next(
                (item for item in participants if str(item.user_id) == str(g.user_id)),
                None,
            )
            break
    if existing_participant:
        return ok(conversation_payload(get_or_404(Conversation, existing_participant.conversation_id, "会话不存在")))

    conversation = Conversation(type="private", name=target.name, avatar=target.avatar, updated_at=datetime.utcnow())
    db.session.add(conversation)
    db.session.flush()
    db.session.add_all([
        Participant(
            conversation_id=conversation.id,
            user_id=current.id,
            user_name=current.name,
            avatar=current.avatar,
            role=current.role,
        ),
        Participant(
            conversation_id=conversation.id,
            user_id=target.id,
            user_name=target.name,
            avatar=target.avatar,
            role=target.role,
        ),
    ])
    db.session.commit()
    return ok(conversation_payload(conversation))


@api_bp.get("/api/conversations/<int:conversation_id>/messages")
@login_required
def messages(conversation_id: int):
    # Reset unread count for the requesting user (mark as read)
    participant = Participant.query.filter_by(
        conversation_id=conversation_id,
        user_id=g.user_id,
    ).first()
    if not participant:
        raise BusinessError("Conversation not found", http_status=404)
    if participant and participant.unread_count > 0:
        participant.unread_count = 0
        db.session.commit()

    query = Message.query.filter_by(conversation_id=conversation_id).order_by(Message.created_at.asc())
    return ok(page_result(query, int(request.args.get("page", 1)), int(request.args.get("pageSize", 20))))


@api_bp.get("/api/conversations/unread-count")
@login_required
def unread_count():
    """Return total unread message count across all conversations for the current user."""
    total = db.session.query(db.func.sum(Participant.unread_count)).filter(
        Participant.user_id == g.user_id
    ).scalar()
    return ok({"count": total or 0})


@api_bp.get("/api/conversations/<int:conversation_id>")
@login_required
def conversation_detail(conversation_id: int):
    participant = Participant.query.filter_by(
        conversation_id=conversation_id,
        user_id=g.user_id,
    ).first()
    if not participant:
        raise BusinessError("Conversation not found", http_status=404)
    return ok(conversation_payload(get_or_404(Conversation, conversation_id, "Conversation not found")))


@api_bp.post("/api/conversations/<int:conversation_id>/messages")
@login_required
def message_send(conversation_id: int):
    conversation = get_or_404(Conversation, conversation_id, "会话不存在")
    participant = Participant.query.filter_by(conversation_id=conversation_id, user_id=g.user_id).first()
    if not participant:
        raise BusinessError("Conversation not found", http_status=404)
    payload = body()
    user = db.session.get(User, g.user_id)
    message = Message(
        conversation_id=conversation_id,
        sender_id=g.user_id,
        sender_name=user.name if user else "",
        sender_avatar=user.avatar if user else "",
        type="text",
        content=payload.get("content", ""),
    )
    conversation.last_message = json.dumps({"type": "text", "content": message.content}, ensure_ascii=False)
    conversation.updated_at = datetime.utcnow()
    db.session.add(message)

    # Increment unread_count for all other participants
    other_participants = Participant.query.filter(
        Participant.conversation_id == conversation_id,
        Participant.user_id != g.user_id
    ).all()
    for p in other_participants:
        p.unread_count = (p.unread_count or 0) + 1

    db.session.commit()
    return ok(message.to_dict())


@api_bp.post("/api/conversations/<int:conversation_id>/messages/<int:message_id>/recall")
@login_required
def message_recall(conversation_id: int, message_id: int):
    conversation = get_or_404(Conversation, conversation_id, "Conversation not found")
    participant = Participant.query.filter_by(conversation_id=conversation_id, user_id=g.user_id).first()
    if not participant:
        raise BusinessError("Conversation not found", http_status=404)
    message = get_or_404(Message, message_id, "Message not found")
    if int(message.conversation_id) != int(conversation_id):
        raise BusinessError("Message does not belong to this conversation")
    if int(message.sender_id) != int(g.user_id):
        raise BusinessError("Only the sender can recall this message", code=403, http_status=403)
    if message.status == "recalled":
        return ok(message.to_dict())
    if message.created_at and datetime.utcnow() - message.created_at > timedelta(minutes=2):
        raise BusinessError("Messages can only be recalled within 2 minutes")

    message.status = "recalled"
    message.content = "消息已撤回"
    latest = Message.query.filter_by(conversation_id=conversation_id).order_by(Message.created_at.desc()).first()
    if latest and int(latest.id) == int(message.id):
        conversation.last_message = json.dumps(
            {"type": "text", "content": "消息已撤回", "status": "recalled"},
            ensure_ascii=False,
        )
        conversation.updated_at = datetime.utcnow()
    db.session.commit()
    return ok(message.to_dict())


@api_bp.get("/api/users/profile")
@login_required
def profile():
    return ok(get_or_404(User, g.user_id, "用户不存在").to_dict())


@api_bp.get("/api/users/<int:user_id>")
@login_required
def user_detail(user_id: int):
    return ok(get_or_404(User, user_id, "用户不存在").to_dict())


@api_bp.put("/api/users/profile")
@login_required
def profile_update():
    user = get_or_404(User, g.user_id, "用户不存在")
    payload = body()
    for api_key, attr in {"name": "name", "avatar": "avatar", "phone": "phone", "email": "email", "subject": "subject", "position": "position"}.items():
        if api_key in payload:
            setattr(user, attr, payload[api_key])
    user.updated_at = datetime.utcnow()
    db.session.commit()
    return ok(user.to_dict())


@api_bp.get("/api/users/class/<int:class_id>")
@login_required
def class_students(class_id: int):
    current = get_or_404(User, g.user_id, "User not found")
    query = User.query.filter_by(class_id=class_id)
    role = str(current.role).upper()
    if role in ("TEACHER", "LEADER") and current.school_id:
        query = query.filter(User.school_id == current.school_id)
    elif role in ("PARENT", "STUDENT"):
        allowed = visible_student_ids(current) or []
        query = query.filter(User.id.in_(allowed or [0]))
    rows = query.order_by(User.name.asc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/users/students")
@login_required
def students():
    current = get_or_404(User, g.user_id, "User not found")
    query = scoped_student_query(current)
    rows = query.order_by(User.class_id.asc(), User.name.asc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/users/contacts")
@login_required
def contacts():
    current = get_or_404(User, g.user_id, "用户不存在")
    manual_ids = [
        item.contact_user_id
        for item in Contact.query.filter_by(owner_id=g.user_id).all()
    ]
    role = str(current.role).lower()
    allowed_roles_by_role = {
        "leader": ["leader", "teacher"],
        "teacher": ["leader", "teacher"],
        "student": ["leader", "teacher", "parent"],
        "parent": ["leader", "teacher", "student"],
    }
    allowed_roles = allowed_roles_by_role.get(role, ["leader", "teacher"])
    query = User.query.filter(User.id != g.user_id)
    query = query.filter(
        or_(
            User.role.in_(allowed_roles + [item.upper() for item in allowed_roles]),
            User.id.in_(manual_ids or [0]),
        )
    )
    if current.school_id:
        query = query.filter(
            or_(
                User.school_id == current.school_id,
                User.id.in_(manual_ids or [0]),
            )
        )
    elif manual_ids:
        query = query.filter(User.id.in_(manual_ids))
    if role == "parent":
        child_ids = visible_student_ids(current) or []
        query = query.filter(
            or_(
                User.role.in_(["leader", "teacher", "LEADER", "TEACHER"]),
                User.id.in_((child_ids + manual_ids) or [0]),
            )
        )
    rows = query.order_by(User.role.asc(), User.name.asc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.post("/api/users/contacts")
@login_required
def contact_add():
    payload = body()
    identifier = str(
        payload.get("identifier")
        or payload.get("account")
        or payload.get("phone")
        or payload.get("email")
        or payload.get("userId")
        or ""
    ).strip()
    if not identifier:
        raise BusinessError("请输入联系人手机号、邮箱或用户ID")

    if identifier.isdigit():
        target = User.query.filter(
            or_(
                User.id == int(identifier),
                User.phone == identifier,
            )
        ).first()
    else:
        target = User.query.filter(
            or_(
                User.email == identifier,
                User.phone == identifier,
            )
        ).first()
    if not target:
        raise BusinessError("联系人不存在")
    if target.id == g.user_id:
        raise BusinessError("不能添加自己为联系人")

    contact = Contact.query.filter_by(owner_id=g.user_id, contact_user_id=target.id).first()
    if not contact:
        contact = Contact(
            owner_id=g.user_id,
            contact_user_id=target.id,
            remark=(payload.get("remark") or "").strip(),
        )
        db.session.add(contact)
    elif "remark" in payload:
        contact.remark = (payload.get("remark") or "").strip()
    db.session.commit()
    return ok(target.to_dict())


@api_bp.get("/api/schools/<int:school_id>")
def school_detail(school_id: int):
    return ok(get_or_404(School, school_id, "学校不存在").to_dict())


@api_bp.get("/api/schools/<int:school_id>/classes")
def school_classes(school_id: int):
    get_or_404(School, school_id, "学校不存在")
    rows = ClassInfo.query.filter_by(school_id=school_id).order_by(ClassInfo.grade.asc(), ClassInfo.name.asc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/schools/<int:school_id>/org-tree")
def org_tree(school_id: int):
    school = get_or_404(School, school_id, "学校不存在")
    classes = ClassInfo.query.filter_by(school_id=school_id).order_by(ClassInfo.grade.asc(), ClassInfo.name.asc()).all()
    grade_map: dict[int, list[ClassInfo]] = {}
    for item in classes:
        grade_map.setdefault(item.grade, []).append(item)
    children = []
    for grade, class_items in grade_map.items():
        children.append({
            "id": grade,
            "name": f"{grade}年级",
            "type": "grade",
            "children": [{"id": item.id, "name": item.name, "type": "class", "children": [], "managerId": item.head_teacher_id} for item in class_items],
            "managerId": None,
        })
    return ok({"id": school.id, "name": school.name, "type": "school", "children": children, "managerId": None})


@api_bp.get("/api/attendance/records")
@login_required
def attendance_records():
    current = get_or_404(User, g.user_id, "User not found")
    student_id = request.args.get("studentId", type=int)
    query = Attendance.query
    if student_id:
        assert_visible_student(current, student_id)
        query = query.filter(Attendance.student_id == student_id)
    else:
        student_ids = [row.id for row in scoped_student_query(current).all()]
        query = query.filter(Attendance.student_id.in_(student_ids or [0]))
    month = request.args.get("month")
    if month:
        query = query.filter(Attendance.date.like(f"{month}-%"))
    rows = query.order_by(Attendance.date.desc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/attendance/today")
@login_required
def attendance_today():
    student_id = request.args.get("studentId", g.user_id, type=int)
    row = Attendance.query.filter_by(student_id=student_id, date=date.today()).first()
    return ok(row.to_dict() if row else {"studentId": student_id, "date": date.today().isoformat(), "status": "not_checked"})


@api_bp.get("/api/attendance/summary")
@login_required
def attendance_summary():
    student_id = request.args.get("studentId", g.user_id, type=int)
    rows = Attendance.query.filter_by(student_id=student_id).all()
    total = len(rows)
    normal = len([row for row in rows if row.status in ("present", "normal")])
    late = len([row for row in rows if row.status == "late"])
    leave = len([row for row in rows if row.status == "leave"])
    absent = len([row for row in rows if row.status == "absent"])
    return ok({"total": total, "normal": normal, "late": late, "leave": leave, "absent": absent, "rate": round(normal / total * 100, 2) if total else 0})


@api_bp.get("/api/attendance/<int:attendance_id>")
@api_bp.get("/api/attendance/records/<int:attendance_id>")
@login_required
def attendance_detail(attendance_id: int):
    return ok(get_or_404(Attendance, attendance_id, "考勤记录不存在").to_dict())


@api_bp.get("/api/grades/reports")
@login_required
def grade_reports():
    current = get_or_404(User, g.user_id, "User not found")
    student_id = request.args.get("studentId", type=int)
    query = GradeReport.query
    if student_id:
        assert_visible_student(current, student_id)
        query = query.filter(GradeReport.student_id == student_id)
    else:
        student_ids = [row.id for row in scoped_student_query(current).all()]
        query = query.filter(GradeReport.student_id.in_(student_ids or [0]))
    rows = query.order_by(GradeReport.exam_date.desc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/grades/<int:grade_id>")
@api_bp.get("/api/grades/reports/<int:grade_id>")
@login_required
def grade_detail(grade_id: int):
    return ok(get_or_404(GradeReport, grade_id, "成绩报告不存在").to_dict())


@api_bp.get("/api/health/records")
@login_required
def health_records():
    current = get_or_404(User, g.user_id, "User not found")
    student_id = request.args.get("studentId", type=int)
    allowed = visible_student_ids(current)
    query = HealthRecord.query
    if student_id:
        if allowed is not None and student_id not in allowed:
            raise BusinessError("No permission to view this health record", code=403, http_status=403)
        query = query.filter(HealthRecord.student_id == student_id)
    elif allowed is not None:
        query = query.filter(HealthRecord.student_id.in_(allowed or [0]))
    elif current.school_id:
        student_query = User.query.with_entities(User.id).filter(
            User.role.in_(["student", "STUDENT"]),
            User.school_id == current.school_id,
        )
        query = query.filter(HealthRecord.student_id.in_(student_query))
    rows = query.order_by(HealthRecord.record_date.desc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/health/<int:record_id>")
@api_bp.get("/api/health/records/<int:record_id>")
@login_required
def health_detail(record_id: int):
    return ok(get_or_404(HealthRecord, record_id, "健康记录不存在").to_dict())


@api_bp.get("/api/evaluations")
@login_required
def evaluations():
    student_id = request.args.get("studentId", g.user_id, type=int)
    rows = Evaluation.query.filter_by(student_id=student_id).order_by(Evaluation.created_at.desc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.post("/api/evaluations")
@login_required
def evaluation_create():
    payload = body()
    teacher = db.session.get(User, g.user_id)
    evaluation = Evaluation(
        student_id=payload.get("studentId"),
        teacher_id=g.user_id,
        teacher_name=teacher.name if teacher else "",
        type=payload.get("type", "daily"),
        period_label=payload.get("periodLabel", ""),
        rating=payload.get("rating", 0),
        tags=json_text(payload.get("tags")),
        content=payload.get("content"),
    )
    db.session.add(evaluation)
    db.session.commit()
    return ok(evaluation.to_dict())


@api_bp.put("/api/evaluations/<int:evaluation_id>")
@login_required
def evaluation_update(evaluation_id: int):
    evaluation = get_or_404(Evaluation, evaluation_id, "评价不存在")
    payload = body()
    for api_key, attr in {"type": "type", "periodLabel": "period_label", "rating": "rating", "content": "content"}.items():
        if api_key in payload:
            setattr(evaluation, attr, payload[api_key])
    if "tags" in payload:
        evaluation.tags = json_text(payload["tags"])
    evaluation.updated_at = datetime.utcnow()
    db.session.commit()
    return ok(evaluation.to_dict())


@api_bp.get("/api/activities")
def activities():
    query = Activity.query
    if request.args.get("status"):
        query = query.filter(Activity.status == request.args["status"])
    query = query.order_by(Activity.created_at.desc())
    return ok(page_result(query, int(request.args.get("page", 1)), int(request.args.get("pageSize", 20))))


@api_bp.get("/api/activities/<int:activity_id>")
def activity_detail(activity_id: int):
    return ok(get_or_404(Activity, activity_id, "活动不存在").to_dict())


@api_bp.post("/api/activities/<int:activity_id>/join")
@login_required
def activity_join(activity_id: int):
    activity = get_or_404(Activity, activity_id, "活动不存在")
    existing = ActivityParticipant.query.filter_by(activity_id=activity_id, user_id=g.user_id).first()
    if existing:
        raise BusinessError("不能重复报名同一个活动")
    if activity.max_participants and activity.participant_count >= activity.max_participants:
        raise BusinessError("活动参与人数已满")
    user = db.session.get(User, g.user_id)
    db.session.add(ActivityParticipant(
        activity_id=activity_id,
        user_id=g.user_id,
        user_name=user.name if user else "",
        role=user.role if user else "",
    ))
    activity.participant_count = (activity.participant_count or 0) + 1
    db.session.commit()
    return ok(None)


@api_bp.get("/api/activities/<int:activity_id>/comments")
def activity_comments(activity_id: int):
    get_or_404(Activity, activity_id, "活动不存在")
    rows = ActivityComment.query.filter_by(activity_id=activity_id).order_by(ActivityComment.created_at.asc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.post("/api/activities/<int:activity_id>/comments")
@login_required
def activity_comment_create(activity_id: int):
    get_or_404(Activity, activity_id, "活动不存在")
    payload = body()
    content = (payload.get("content") or "").strip()
    if not content:
        raise BusinessError("评论内容不能为空")
    user = db.session.get(User, g.user_id)
    comment = ActivityComment(
        activity_id=activity_id,
        user_id=g.user_id,
        user_name=user.name if user else "",
        user_avatar=user.avatar if user else "",
        role=user.role if user else "",
        content=content,
    )
    db.session.add(comment)
    db.session.commit()
    return ok(comment.to_dict())


def require_staff():
    user = db.session.get(User, g.user_id)
    if not user or str(user.role).upper() not in ("TEACHER", "LEADER"):
        raise BusinessError("仅教师和领导可执行此操作", code=403, http_status=403)
    return user


@api_bp.put("/api/homework/<int:homework_id>")
@login_required
def homework_update(homework_id: int):
    require_staff()
    homework = get_or_404(Homework, homework_id, "作业不存在")
    payload = body()
    for api_key, attr in {"subject": "subject", "title": "title", "content": "content", "class_id": "class_id", "class_name": "class_name", "status": "status"}.items():
        if api_key in payload:
            setattr(homework, attr, payload[api_key])
    if "dueDate" in payload:
        homework.due_date = parse_dt(payload["dueDate"])
    if "attachments" in payload:
        homework.attachments = json_text(payload["attachments"])
    homework.updated_at = datetime.utcnow()
    db.session.commit()
    return ok(homework.to_dict())


@api_bp.delete("/api/homework/<int:homework_id>")
@login_required
def homework_delete(homework_id: int):
    require_staff()
    homework = get_or_404(Homework, homework_id, "作业不存在")
    db.session.delete(homework)
    db.session.commit()
    return ok(None)


@api_bp.get("/api/homework/<int:homework_id>/submissions")
@login_required
def homework_submissions(homework_id: int):
    require_staff()
    rows = Submission.query.filter_by(homework_id=homework_id).order_by(Submission.submitted_at.desc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.post("/api/health/records")
@login_required
def health_record_create():
    current = require_staff()
    payload = body()
    student_id = parse_int_id(payload.get("studentId"), "studentId")
    student = assert_visible_student(current, student_id)
    record = HealthRecord(
        student_id=student_id,
        student_name=payload.get("studentName") or student.name,
        class_name=payload.get("className") or student.class_name,
        record_date=parse_dt(payload.get("recordDate")),
        height=payload.get("height", 0),
        weight=payload.get("weight", 0),
        bmi=payload.get("bmi", 0),
        vision_left=payload.get("visionLeft", 0),
        vision_right=payload.get("visionRight", 0),
        temperature=payload.get("temperature", 0),
        blood_pressure=payload.get("bloodPressure", ""),
        heart_rate=payload.get("heartRate", 0),
        vaccinations=json_text(payload.get("vaccinations")),
        medical_history=payload.get("medicalHistory", ""),
        allergies=payload.get("allergies", ""),
        health_status=payload.get("healthStatus", "healthy"),
    )
    db.session.add(record)
    db.session.commit()
    return ok(record.to_dict())


@api_bp.put("/api/health/records/<int:record_id>")
@login_required
def health_record_update(record_id: int):
    require_staff()
    record = get_or_404(HealthRecord, record_id, "健康记录不存在")
    payload = body()
    for api_key, attr in {
        "studentName": "student_name", "className": "class_name",
        "height": "height", "weight": "weight", "bmi": "bmi",
        "visionLeft": "vision_left", "visionRight": "vision_right",
        "temperature": "temperature", "bloodPressure": "blood_pressure",
        "heartRate": "heart_rate", "medicalHistory": "medical_history",
        "allergies": "allergies", "healthStatus": "health_status",
    }.items():
        if api_key in payload:
            setattr(record, attr, payload[api_key])
    if "recordDate" in payload:
        record.record_date = parse_dt(payload["recordDate"])
    if "vaccinations" in payload:
        record.vaccinations = json_text(payload["vaccinations"])
    record.updated_at = datetime.utcnow()
    db.session.commit()
    return ok(record.to_dict())


@api_bp.delete("/api/health/records/<int:record_id>")
@login_required
def health_record_delete(record_id: int):
    require_staff()
    record = get_or_404(HealthRecord, record_id, "健康记录不存在")
    db.session.delete(record)
    db.session.commit()
    return ok(None)


@api_bp.post("/api/activities")
@login_required
def activity_create():
    require_staff()
    payload = body()
    user = db.session.get(User, g.user_id)
    activity = Activity(
        title=payload.get("title", ""),
        description=payload.get("description"),
        cover_image=payload.get("coverImage", ""),
        organizer_id=g.user_id,
        organizer_name=user.name if user else "",
        location=payload.get("location", ""),
        start_time=parse_dt(payload.get("startTime")),
        end_time=parse_dt(payload.get("endTime")),
        max_participants=payload.get("maxParticipants", 0),
        photos=json_text(payload.get("photos")),
        status=payload.get("status", "upcoming"),
    )
    db.session.add(activity)
    db.session.commit()
    return ok(activity.to_dict())


@api_bp.put("/api/activities/<int:activity_id>")
@login_required
def activity_update(activity_id: int):
    require_staff()
    activity = get_or_404(Activity, activity_id, "活动不存在")
    payload = body()
    for api_key, attr in {
        "title": "title", "description": "description", "coverImage": "cover_image",
        "location": "location", "status": "status", "maxParticipants": "max_participants",
    }.items():
        if api_key in payload:
            setattr(activity, attr, payload[api_key])
    if "startTime" in payload:
        activity.start_time = parse_dt(payload["startTime"])
    if "endTime" in payload:
        activity.end_time = parse_dt(payload["endTime"])
    if "photos" in payload:
        activity.photos = json_text(payload["photos"])
    db.session.commit()
    return ok(activity.to_dict())


@api_bp.delete("/api/activities/<int:activity_id>")
@login_required
def activity_delete(activity_id: int):
    require_staff()
    activity = get_or_404(Activity, activity_id, "活动不存在")
    db.session.delete(activity)
    db.session.commit()
    return ok(None)


@api_bp.post("/api/attendance")
@login_required
def attendance_create():
    current = require_staff()
    payload = body()
    student_id = parse_int_id(payload.get("studentId"), "studentId")
    student = assert_visible_student(current, student_id)
    record = Attendance(
        student_id=student_id,
        student_name=payload.get("studentName") or student.name,
        student_avatar=student.avatar or "",
        class_id=student.class_id,
        class_name=payload.get("className") or student.class_name,
        date=parse_date(payload.get("date")) or date.today(),
        day_of_week=payload.get("dayOfWeek", ""),
        check_in_time=parse_time(payload.get("checkInTime")),
        status=payload.get("status", "present"),
        method=payload.get("method", "card"),
        remark=payload.get("remark", ""),
    )
    db.session.add(record)
    db.session.commit()
    return ok(record.to_dict())


@api_bp.put("/api/attendance/<int:attendance_id>")
@login_required
def attendance_update(attendance_id: int):
    current = require_staff()
    record = get_or_404(Attendance, attendance_id, "考勤记录不存在")
    assert_visible_student(current, int(record.student_id))
    payload = body()
    for api_key, attr in {
        "status": "status", "remark": "remark", "method": "method",
        "studentName": "student_name", "dayOfWeek": "day_of_week",
    }.items():
        if api_key in payload:
            setattr(record, attr, payload[api_key])
    if "date" in payload:
        record.date = parse_date(payload["date"])
    if "checkInTime" in payload:
        record.check_in_time = parse_time(payload["checkInTime"])
    db.session.commit()
    return ok(record.to_dict())


@api_bp.delete("/api/attendance/<int:attendance_id>")
@login_required
def attendance_delete(attendance_id: int):
    require_staff()
    record = get_or_404(Attendance, attendance_id, "考勤记录不存在")
    db.session.delete(record)
    db.session.commit()
    return ok(None)


@api_bp.post("/api/grades/reports")
@login_required
def grade_report_create():
    current = require_staff()
    payload = body()
    student_id = parse_int_id(payload.get("studentId"), "studentId")
    student = assert_visible_student(current, student_id)
    report = GradeReport(
        student_id=student_id,
        student_name=payload.get("studentName") or student.name,
        class_name=payload.get("className") or student.class_name,
        exam_name=payload.get("examName", ""),
        exam_date=parse_dt(payload.get("examDate")),
        subjects=json_text(payload.get("subjects")),
        total_score=payload.get("totalScore", 0),
        total_full_score=payload.get("totalFullScore", 0),
        class_rank=payload.get("classRank", 0),
        class_size=payload.get("classSize", 0),
        grade_rank=payload.get("gradeRank", 0),
        grade_size=payload.get("gradeSize", 0),
        teacher_comment=payload.get("teacherComment", ""),
    )
    db.session.add(report)
    db.session.commit()
    return ok(report.to_dict())


@api_bp.delete("/api/evaluations/<int:evaluation_id>")
@login_required
def evaluation_delete(evaluation_id: int):
    require_staff()
    evaluation = get_or_404(Evaluation, evaluation_id, "评价不存在")
    db.session.delete(evaluation)
    db.session.commit()
    return ok(None)


@api_bp.get("/api/users/class/<int:class_id>/members")
@login_required
def class_members(class_id: int):
    rows = User.query.filter_by(class_id=class_id).order_by(User.role.asc(), User.name.asc()).all()
    return ok([row.to_dict() for row in rows])
