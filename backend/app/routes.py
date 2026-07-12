from __future__ import annotations

import json
from datetime import date, datetime

from flask import Blueprint, g, jsonify, request

from . import BusinessError
from .extensions import db
from .models import (
    Activity,
    Attendance,
    ClassInfo,
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
    return {
        "records": [serializer(item) for item in pagination.items],
        "total": pagination.total,
        "page": page,
        "pageSize": page_size,
    }


def body() -> dict:
    return request.get_json(silent=True) or {}


def parse_dt(value):
    if not value:
        return None
    if isinstance(value, datetime):
        return value
    normalized = str(value).replace("Z", "+00:00")
    try:
        return datetime.fromisoformat(normalized)
    except ValueError:
        return None


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
    user = User.query.filter_by(phone=payload.get("phone")).first()
    if not user or not verify_password(payload.get("password", ""), user.password):
        raise BusinessError("手机号或密码错误", code=1001)
    return ok({"user": user.to_dict(), "token": generate_token(user.id, user.role)})


@api_bp.post("/api/auth/register")
def register():
    payload = body()
    required = ["name", "phone", "password", "role"]
    if any(not payload.get(field) for field in required):
        raise BusinessError("姓名、手机号、密码和角色不能为空")
    if User.query.filter_by(phone=payload["phone"]).first():
        raise BusinessError("该手机号已被注册")
    user = User(
        name=payload["name"],
        phone=payload["phone"],
        password=hash_password(payload["password"]),
        role=payload["role"],
        school_id=payload.get("schoolId"),
        class_id=payload.get("classId"),
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
    query = Homework.query.order_by(Homework.assigned_at.desc())
    return ok(page_result(query, int(request.args.get("page", 1)), int(request.args.get("pageSize", 20))))


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
    submission = Submission.query.filter_by(homework_id=homework_id, student_id=g.user_id).first()
    if not submission:
        raise BusinessError("未找到提交记录")
    return ok(submission.to_dict())


@api_bp.post("/api/homework/<int:homework_id>/submission")
@login_required
def homework_submit(homework_id: int):
    get_or_404(Homework, homework_id, "作业不存在")
    payload = body()
    submission = Submission.query.filter_by(homework_id=homework_id, student_id=g.user_id).first()
    created = submission is None
    if created:
        submission = Submission(homework_id=homework_id, student_id=g.user_id)
        db.session.add(submission)
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
    submission.score = request.args.get("score", type=int)
    submission.teacher_comment = request.args.get("comment", "")
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
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/conversations/<int:conversation_id>/messages")
@login_required
def messages(conversation_id: int):
    query = Message.query.filter_by(conversation_id=conversation_id).order_by(Message.created_at.asc())
    return ok(page_result(query, int(request.args.get("page", 1)), int(request.args.get("pageSize", 20))))


@api_bp.post("/api/conversations/<int:conversation_id>/messages")
@login_required
def message_send(conversation_id: int):
    conversation = get_or_404(Conversation, conversation_id, "会话不存在")
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
    db.session.commit()
    return ok(message.to_dict())


@api_bp.get("/api/users/profile")
@login_required
def profile():
    return ok(get_or_404(User, g.user_id, "用户不存在").to_dict())


@api_bp.put("/api/users/profile")
@login_required
def profile_update():
    user = get_or_404(User, g.user_id, "用户不存在")
    payload = body()
    for api_key, attr in {"name": "name", "avatar": "avatar", "phone": "phone", "subject": "subject", "position": "position"}.items():
        if api_key in payload:
            setattr(user, attr, payload[api_key])
    user.updated_at = datetime.utcnow()
    db.session.commit()
    return ok(user.to_dict())


@api_bp.get("/api/users/class/<int:class_id>")
@login_required
def class_students(class_id: int):
    rows = User.query.filter_by(class_id=class_id).order_by(User.name.asc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/schools/<int:school_id>")
def school_detail(school_id: int):
    return ok(get_or_404(School, school_id, "学校不存在").to_dict())


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
    student_id = request.args.get("studentId", g.user_id, type=int)
    query = Attendance.query.filter_by(student_id=student_id)
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
    normal = len([row for row in rows if row.status == "normal"])
    late = len([row for row in rows if row.status == "late"])
    leave = len([row for row in rows if row.status == "leave"])
    absent = len([row for row in rows if row.status == "absent"])
    return ok({"total": total, "normal": normal, "late": late, "leave": leave, "absent": absent, "rate": round(normal / total * 100, 2) if total else 0})


@api_bp.get("/api/attendance/<int:attendance_id>")
@login_required
def attendance_detail(attendance_id: int):
    return ok(get_or_404(Attendance, attendance_id, "考勤记录不存在").to_dict())


@api_bp.get("/api/grades/reports")
@login_required
def grade_reports():
    student_id = request.args.get("studentId", g.user_id, type=int)
    rows = GradeReport.query.filter_by(student_id=student_id).order_by(GradeReport.exam_date.desc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/grades/<int:grade_id>")
@login_required
def grade_detail(grade_id: int):
    return ok(get_or_404(GradeReport, grade_id, "成绩报告不存在").to_dict())


@api_bp.get("/api/health/records")
@login_required
def health_records():
    student_id = request.args.get("studentId", g.user_id, type=int)
    rows = HealthRecord.query.filter_by(student_id=student_id).order_by(HealthRecord.record_date.desc()).all()
    return ok([row.to_dict() for row in rows])


@api_bp.get("/api/health/<int:record_id>")
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
    query = Activity.query.order_by(Activity.created_at.desc())
    return ok(page_result(query, int(request.args.get("page", 1)), int(request.args.get("pageSize", 20))))


@api_bp.get("/api/activities/<int:activity_id>")
def activity_detail(activity_id: int):
    return ok(get_or_404(Activity, activity_id, "活动不存在").to_dict())


@api_bp.post("/api/activities/<int:activity_id>/join")
@login_required
def activity_join(activity_id: int):
    activity = get_or_404(Activity, activity_id, "活动不存在")
    if activity.max_participants and activity.participant_count >= activity.max_participants:
        raise BusinessError("活动参与人数已满")
    activity.participant_count = (activity.participant_count or 0) + 1
    db.session.commit()
    return ok(None)
