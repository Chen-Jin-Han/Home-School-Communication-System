from datetime import date, datetime, timedelta, time

from .extensions import db
from .models import (
    Attendance,
    ClassInfo,
    Evaluation,
    GradeReport,
    HealthRecord,
    Homework,
    Notice,
    School,
    User,
)
from .security import hash_password


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
            address="华迪市华德区教育路88号",
            phone="0512-88888888",
            principal="王校长",
            founded_year=1995,
        )
    )
    db.session.add_all(
        [
            ClassInfo(id=1, name="一年级(1)班", grade=1, school_id=1, head_teacher_id=3, head_teacher_name="李老师", student_count=40),
            ClassInfo(id=2, name="三年级(2)班", grade=3, school_id=1, head_teacher_id=3, head_teacher_name="李老师", student_count=40),
            ClassInfo(id=3, name="五年级(1)班", grade=5, school_id=1, student_count=35),
        ]
    )
    db.session.add_all(
        [
            User(id=1, name="张伟", phone="13800000001", password=password, role="PARENT", school_id=1, school_name="华迪小学", class_id=2, class_name="三年级(2)班", grade=3, child_ids="[2]", child_names='["张小伟"]'),
            User(id=2, name="张小伟", phone="13800000002", password=password, role="STUDENT", school_id=1, school_name="华迪小学", class_id=2, class_name="三年级(2)班", grade=3),
            User(id=3, name="李老师", phone="13800000003", password=password, role="TEACHER", school_id=1, school_name="华迪小学", class_id=2, class_name="三年级(2)班", grade=3, subject="语文"),
            User(id=4, name="王校长", phone="13800000004", password=password, role="LEADER", school_id=1, school_name="华迪小学", position="校长"),
        ]
    )
    db.session.add_all(
        [
            Notice(id=1, title="关于开展2026年春季运动会的通知", summary="学校将举行春季运动会，请各班做好报名准备", content="为丰富校园文化生活，增强学生体质，学校将于本月举行春季运动会。", type="notification", publisher_id=4, publisher_name="王校长", scope="all", is_top=True, view_count=532, created_at=now - timedelta(days=2), updated_at=now - timedelta(days=2)),
            Notice(id=2, title="三年级语文教研活动公告", summary="本周三下午举行语文教研活动", content="本次教研活动主题为阅读教学创新方法。", type="announcement", publisher_id=3, publisher_name="李老师", scope="grade", is_top=True, view_count=156, created_at=now - timedelta(days=3), updated_at=now - timedelta(days=3)),
            Notice(id=3, title="华迪小学荣获市级文明校园称号", summary="我校被评为市级文明校园", content="经过全体师生共同努力，我校获得市级文明校园荣誉。", type="news", publisher_id=4, publisher_name="王校长", scope="all", view_count=1203, created_at=now - timedelta(days=5), updated_at=now - timedelta(days=5)),
        ]
    )
    db.session.add_all(
        [
            Homework(id=1, subject="语文", title="背诵古诗《静夜思》并默写", content="熟读古诗三遍，理解诗意并完成默写。", teacher_id=3, teacher_name="李老师", class_id=2, class_name="三年级(2)班", due_date=now + timedelta(days=2), assigned_at=now - timedelta(days=1), submission_count=18, total_students=40),
            Homework(id=2, subject="数学", title="完成习题册第45-48页", content="完成应用题和计算题，注意书写规范。", teacher_id=3, teacher_name="李老师", class_id=2, class_name="三年级(2)班", due_date=now + timedelta(days=1), assigned_at=now - timedelta(days=2), submission_count=25, total_students=40),
        ]
    )
    db.session.add_all(
        [
            Attendance(student_id=2, student_name="张小伟", class_id=2, class_name="三年级(2)班", date=date.today(), day_of_week="周一", check_in_time=time(7, 50), status="normal"),
            Attendance(student_id=2, student_name="张小伟", class_id=2, class_name="三年级(2)班", date=date.today() - timedelta(days=1), day_of_week="周日", check_in_time=time(8, 5), status="late"),
            Attendance(student_id=2, student_name="张小伟", class_id=2, class_name="三年级(2)班", date=date.today() - timedelta(days=2), day_of_week="周六", status="leave"),
        ]
    )
    db.session.add_all(
        [
            GradeReport(student_id=2, student_name="张小伟", class_name="三年级(2)班", exam_name="2026年春季期中考试", exam_date=now - timedelta(days=60), subjects='[{"subject":"语文","score":92,"fullScore":100},{"subject":"数学","score":88,"fullScore":100},{"subject":"英语","score":95,"fullScore":100}]', total_score=275, total_full_score=300, class_rank=10, class_size=40, grade_rank=42, grade_size=200, teacher_comment="学习认真，语文和英语进步明显。"),
            HealthRecord(student_id=2, student_name="张小伟", class_name="三年级(2)班", record_date=now - timedelta(days=30), height=135, weight=32, bmi=17.6, vision_left=5.0, vision_right=5.1, temperature=36.5, blood_pressure="100/65", heart_rate=85, health_status="healthy"),
            Evaluation(student_id=2, student_name="张小伟", teacher_id=3, teacher_name="李老师", type="weekly", period_label="2026年7月第1周", rating=4, tags='["积极发言","作业认真","团结同学"]', content="本周课堂表现良好，作业完成质量较高。"),
        ]
    )

    db.session.commit()
