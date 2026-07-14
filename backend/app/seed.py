import json
from datetime import date, datetime, timedelta, time

from sqlalchemy import inspect, text

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
    User,
)
from .security import hash_password


def ensure_schema() -> None:
    """Apply tiny startup-safe additions for local Docker databases."""
    inspector = inspect(db.engine)
    if "user" not in inspector.get_table_names():
        return

    def ensure_participant_unread_count() -> None:
        if "participant" not in inspector.get_table_names():
            return
        participant_cols = {col["name"] for col in inspector.get_columns("participant")}
        if "unread_count" not in participant_cols:
            db.session.execute(text("ALTER TABLE participant ADD COLUMN unread_count INTEGER DEFAULT 0"))
            db.session.commit()

    columns = {column["name"] for column in inspector.get_columns("user")}
    if db.engine.dialect.name == "mysql":
        db.session.execute(text("ALTER TABLE `user` MODIFY phone VARCHAR(20) NULL"))
    if "email" in columns:
        db.session.commit()
        ensure_participant_unread_count()
        return

    if db.engine.dialect.name == "mysql":
        db.session.execute(text("ALTER TABLE `user` ADD COLUMN email VARCHAR(120) NULL"))
        db.session.execute(text("CREATE UNIQUE INDEX ix_user_email ON `user` (email)"))
    else:
        db.session.execute(text("ALTER TABLE user ADD COLUMN email VARCHAR(120)"))
        db.session.execute(text("CREATE UNIQUE INDEX ix_user_email ON user (email)"))
    db.session.commit()

    ensure_participant_unread_count()


def as_json(value) -> str:
    return json.dumps(value, ensure_ascii=False)


def seed_data() -> None:
    if db.session.get(School, 1):
        return

    password = hash_password("123456")
    now = datetime.utcnow()

    db.session.add(
        School(
            id=1,
            name="华迪小学",
            description="华迪小学是一所面向未来的智慧校园示范学校，重视家校协同与学生全面发展。",
            address="华迪市华德区教育路 88 号",
            phone="0512-88888888",
            principal="王校长",
            founded_year=1995,
        )
    )

    db.session.add_all([
        ClassInfo(id=1, name="一年级(1)班", grade=1, school_id=1, head_teacher_id=3, head_teacher_name="李老师", student_count=36),
        ClassInfo(id=2, name="三年级(2)班", grade=3, school_id=1, head_teacher_id=3, head_teacher_name="李老师", student_count=40),
        ClassInfo(id=3, name="五年级(1)班", grade=5, school_id=1, student_count=35),
    ])

    db.session.add_all([
        User(id=1, name="张伟", phone="13800000001", email="parent@huadee.test", password=password, role="parent", school_id=1, school_name="华迪小学", class_id=2, class_name="三年级(2)班", grade=3, child_ids=as_json([2]), child_names=as_json(["张小伟"])),
        User(id=2, name="张小伟", phone="13800000002", email="student@huadee.test", password=password, role="student", school_id=1, school_name="华迪小学", class_id=2, class_name="三年级(2)班", grade=3),
        User(id=3, name="李老师", phone="13800000003", email="teacher@huadee.test", password=password, role="teacher", school_id=1, school_name="华迪小学", class_id=2, class_name="三年级(2)班", grade=3, subject="语文"),
        User(id=4, name="王校长", phone="13800000004", email="leader@huadee.test", password=password, role="leader", school_id=1, school_name="华迪小学", position="校长"),
        User(id=5, name="李小萌", phone="13800000005", email="student2@huadee.test", password=password, role="student", school_id=1, school_name="华迪小学", class_id=2, class_name="三年级(2)班", grade=3),
        User(id=6, name="赵敏", phone="13800000006", email="parent2@huadee.test", password=password, role="parent", school_id=1, school_name="华迪小学", class_id=2, class_name="三年级(2)班", grade=3, child_ids=as_json([5]), child_names=as_json(["李小萌"])),
    ])

    db.session.add_all([
        Notice(id=1, title="关于开展 2026 年春季运动会的通知", summary="学校将举行春季运动会，请各班做好报名准备。", content="为丰富校园文化生活、增强学生体质，学校将于本月举行春季运动会。请各班主任组织学生报名并做好安全教育。", type="notification", publisher_id=4, publisher_name="王校长", scope="all", is_top=True, view_count=532, created_at=now - timedelta(days=2), updated_at=now - timedelta(days=2)),
        Notice(id=2, title="三年级语文教研活动公告", summary="本周三下午举行语文教研活动。", content="本次教研活动主题为阅读教学创新方法，请三年级语文组教师准时参加。", type="announcement", publisher_id=3, publisher_name="李老师", scope="grade", is_top=True, view_count=156, created_at=now - timedelta(days=3), updated_at=now - timedelta(days=3)),
        Notice(id=3, title="华迪小学荣获市级文明校园称号", summary="我校被评为市级文明校园。", content="经过全体师生共同努力，我校获得市级文明校园荣誉称号。", type="news", publisher_id=4, publisher_name="王校长", scope="all", view_count=1203, created_at=now - timedelta(days=5), updated_at=now - timedelta(days=5)),
    ])

    db.session.add_all([
        Homework(id=1, subject="语文", title="背诵古诗《静夜思》并默写", content="熟读古诗三遍，理解诗意并完成默写。", teacher_id=3, teacher_name="李老师", class_id=2, class_name="三年级(2)班", due_date=now + timedelta(days=2), assigned_at=now - timedelta(days=1), submission_count=18, total_students=40, status="active"),
        Homework(id=2, subject="数学", title="完成习题册第 45-48 页", content="完成应用题和计算题，注意书写规范。", teacher_id=3, teacher_name="李老师", class_id=2, class_name="三年级(2)班", due_date=now + timedelta(days=1), assigned_at=now - timedelta(days=2), submission_count=25, total_students=40, status="active"),
    ])

    db.session.add_all([
        Attendance(student_id=2, student_name="张小伟", class_id=2, class_name="三年级(2)班", date=date.today(), day_of_week="周一", check_in_time=time(7, 50), status="present"),
        Attendance(student_id=2, student_name="张小伟", class_id=2, class_name="三年级(2)班", date=date.today() - timedelta(days=1), day_of_week="周日", check_in_time=time(8, 5), status="late", remark="早高峰迟到 5 分钟"),
        Attendance(student_id=2, student_name="张小伟", class_id=2, class_name="三年级(2)班", date=date.today() - timedelta(days=2), day_of_week="周六", status="leave", remark="家长已请假"),
    ])

    db.session.add_all([
        GradeReport(student_id=2, student_name="张小伟", class_name="三年级(2)班", exam_name="2026 年春季学期期中考试", exam_date=now - timedelta(days=60), subjects=as_json([{"subject": "语文", "score": 92, "fullScore": 100}, {"subject": "数学", "score": 88, "fullScore": 100}, {"subject": "英语", "score": 95, "fullScore": 100}]), total_score=275, total_full_score=300, class_rank=10, class_size=40, grade_rank=42, grade_size=200, teacher_comment="学习认真，语文和英语进步明显。"),
        HealthRecord(student_id=2, student_name="张小伟", class_name="三年级(2)班", record_date=now - timedelta(days=30), height=135, weight=32, bmi=17.6, vision_left=5.0, vision_right=5.1, temperature=36.5, blood_pressure="100/65", heart_rate=85, health_status="healthy", vaccinations=as_json(["流感疫苗"])),
        Evaluation(student_id=2, student_name="张小伟", teacher_id=3, teacher_name="李老师", type="weekly", period_label="2026 年 7 月第 1 周", rating=4, tags=as_json(["积极发言", "作业认真", "团结同学"]), content="本周课堂表现良好，作业完成质量较高。"),
    ])

    conversation = Conversation(id=1, type="private", name="李老师", last_message=as_json({"type": "text", "content": "今天作业完成得不错，请继续保持。"}), unread_count=1, updated_at=now - timedelta(hours=2))
    db.session.add(conversation)
    db.session.flush()
    db.session.add_all([
        Participant(conversation_id=1, user_id=1, user_name="张伟", role="parent", unread_count=1),
        Participant(conversation_id=1, user_id=3, user_name="李老师", role="teacher", unread_count=0),
        Message(conversation_id=1, sender_id=3, sender_name="李老师", type="text", content="今天作业完成得不错，请继续保持。", created_at=now - timedelta(hours=2), status="sent"),
        Message(conversation_id=1, sender_id=1, sender_name="张伟", type="text", content="收到，谢谢老师。", created_at=now - timedelta(hours=1, minutes=50), status="sent"),
    ])

    db.session.add_all([
        Activity(id=1, title="春季亲子运动会", description="邀请家长和孩子一起参加趣味运动项目，增进家校互动。", organizer_id=4, organizer_name="王校长", location="学校操场", start_time=now + timedelta(days=7), end_time=now + timedelta(days=7, hours=3), participant_count=86, max_participants=200, status="upcoming", created_at=now - timedelta(days=2)),
        Activity(id=2, title="校园阅读分享会", description="三年级学生分享本月阅读书目，教师进行阅读方法指导。", organizer_id=3, organizer_name="李老师", location="图书馆二楼", start_time=now + timedelta(days=3), end_time=now + timedelta(days=3, hours=2), participant_count=32, max_participants=60, status="upcoming", created_at=now - timedelta(days=1)),
    ])

    db.session.commit()
