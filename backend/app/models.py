from __future__ import annotations

import json
from datetime import date, datetime, time
from decimal import Decimal

from .extensions import db


def camelize(name: str) -> str:
    head, *tail = name.split("_")
    return head + "".join(part[:1].upper() + part[1:] for part in tail)


class SerializerMixin:
    json_fields: set[str] = set()
    hidden_fields: set[str] = set()

    def to_dict(self) -> dict:
        data = {}
        for column in self.__table__.columns:
            key = column.name
            if key in self.hidden_fields:
                continue
            value = getattr(self, key)
            if key in self.json_fields and isinstance(value, str):
                try:
                    value = json.loads(value or "[]")
                except json.JSONDecodeError:
                    pass
            elif isinstance(value, (datetime, date, time)):
                value = value.isoformat()
            elif isinstance(value, Decimal):
                value = float(value)
            data[camelize(key)] = value
        return data


class School(db.Model, SerializerMixin):
    __tablename__ = "school"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    logo = db.Column(db.String(500), default="")
    description = db.Column(db.Text)
    address = db.Column(db.String(200), default="")
    phone = db.Column(db.String(20), default="")
    principal = db.Column(db.String(50), default="")
    founded_year = db.Column(db.Integer, default=0)


class ClassInfo(db.Model, SerializerMixin):
    __tablename__ = "class_info"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    grade = db.Column(db.Integer, default=1)
    school_id = db.Column(db.BigInteger, nullable=False, index=True)
    head_teacher_id = db.Column(db.BigInteger)
    head_teacher_name = db.Column(db.String(50), default="")
    student_count = db.Column(db.Integer, default=0)


class User(db.Model, SerializerMixin):
    __tablename__ = "user"
    hidden_fields = {"password"}
    json_fields = {"child_ids", "child_names"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(50), nullable=False)
    phone = db.Column(db.String(20), unique=True, index=True)
    email = db.Column(db.String(120), unique=True, index=True)
    password = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(20), nullable=False, default="PARENT")
    avatar = db.Column(db.String(500), default="")
    school_id = db.Column(db.BigInteger, index=True)
    school_name = db.Column(db.String(100), default="")
    class_id = db.Column(db.BigInteger, index=True)
    class_name = db.Column(db.String(100), default="")
    grade = db.Column(db.Integer, default=0)
    child_ids = db.Column(db.String(500), default="[]")
    child_names = db.Column(db.String(500), default="[]")
    subject = db.Column(db.String(50), default="")
    position = db.Column(db.String(50), default="")
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def to_dict(self) -> dict:
        data = super().to_dict()
        if data.get("role"):
            data["role"] = str(data["role"]).lower()
        return data


class Contact(db.Model, SerializerMixin):
    __tablename__ = "contact"
    __table_args__ = (
        db.UniqueConstraint("owner_id", "contact_user_id", name="uq_contact_owner_user"),
    )

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    owner_id = db.Column(db.BigInteger, nullable=False, index=True)
    contact_user_id = db.Column(db.BigInteger, nullable=False, index=True)
    remark = db.Column(db.String(50), default="")
    source = db.Column(db.String(20), default="manual")
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)


class Notice(db.Model, SerializerMixin):
    __tablename__ = "notice"
    json_fields = {"attachments"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String(200), nullable=False)
    summary = db.Column(db.String(500), default="")
    content = db.Column(db.Text)
    type = db.Column(db.String(20), default="notification", index=True)
    publisher_id = db.Column(db.BigInteger, nullable=False)
    publisher_name = db.Column(db.String(50), default="")
    publisher_avatar = db.Column(db.String(500), default="")
    scope = db.Column(db.String(20), default="all")
    scope_target_id = db.Column(db.BigInteger)
    attachments = db.Column(db.Text, default="[]")
    is_top = db.Column(db.Boolean, default=False)
    view_count = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class Conversation(db.Model, SerializerMixin):
    __tablename__ = "conversation"
    json_fields = {"last_message"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    type = db.Column(db.String(20), default="private")
    name = db.Column(db.String(100), default="")
    avatar = db.Column(db.String(500), default="")
    last_message = db.Column(db.Text, default="{}")
    unread_count = db.Column(db.Integer, default=0)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)


class Participant(db.Model, SerializerMixin):
    __tablename__ = "participant"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    conversation_id = db.Column(db.BigInteger, nullable=False, index=True)
    user_id = db.Column(db.BigInteger, nullable=False, index=True)
    user_name = db.Column(db.String(50), default="")
    avatar = db.Column(db.String(500), default="")
    role = db.Column(db.String(20), default="")


class Message(db.Model, SerializerMixin):
    __tablename__ = "message"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    conversation_id = db.Column(db.BigInteger, nullable=False, index=True)
    sender_id = db.Column(db.BigInteger, nullable=False, index=True)
    sender_name = db.Column(db.String(50), default="")
    sender_avatar = db.Column(db.String(500), default="")
    type = db.Column(db.String(20), default="text")
    content = db.Column(db.Text)
    duration = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    status = db.Column(db.String(20), default="sent")


class Homework(db.Model, SerializerMixin):
    __tablename__ = "homework"
    json_fields = {"attachments"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    subject = db.Column(db.String(50), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text)
    teacher_id = db.Column(db.BigInteger, nullable=False)
    teacher_name = db.Column(db.String(50), default="")
    class_id = db.Column(db.BigInteger, nullable=False, index=True)
    class_name = db.Column(db.String(100), default="")
    attachments = db.Column(db.Text, default="[]")
    due_date = db.Column(db.DateTime)
    assigned_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    submission_count = db.Column(db.Integer, default=0)
    total_students = db.Column(db.Integer, default=0)
    status = db.Column(db.String(20), default="active")


class Submission(db.Model, SerializerMixin):
    __tablename__ = "submission"
    json_fields = {"attachments"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    homework_id = db.Column(db.BigInteger, nullable=False, index=True)
    student_id = db.Column(db.BigInteger, nullable=False, index=True)
    student_name = db.Column(db.String(50), default="")
    student_avatar = db.Column(db.String(500), default="")
    content = db.Column(db.Text)
    attachments = db.Column(db.Text, default="[]")
    submitted_at = db.Column(db.DateTime, default=datetime.utcnow)
    score = db.Column(db.Integer)
    teacher_comment = db.Column(db.String(500), default="")
    status = db.Column(db.String(20), default="submitted")


class Activity(db.Model, SerializerMixin):
    __tablename__ = "activity"
    json_fields = {"photos"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    cover_image = db.Column(db.String(500), default="")
    organizer_id = db.Column(db.BigInteger, nullable=False)
    organizer_name = db.Column(db.String(50), default="")
    location = db.Column(db.String(200), default="")
    start_time = db.Column(db.DateTime)
    end_time = db.Column(db.DateTime)
    participant_count = db.Column(db.Integer, default=0)
    max_participants = db.Column(db.Integer, default=0)
    photos = db.Column(db.Text, default="[]")
    status = db.Column(db.String(20), default="upcoming")
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)


class Attendance(db.Model, SerializerMixin):
    __tablename__ = "attendance"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    student_id = db.Column(db.BigInteger, nullable=False, index=True)
    student_name = db.Column(db.String(50), default="")
    student_avatar = db.Column(db.String(500), default="")
    class_id = db.Column(db.BigInteger, nullable=False, index=True)
    class_name = db.Column(db.String(100), default="")
    date = db.Column(db.Date, index=True)
    day_of_week = db.Column(db.String(10), default="")
    check_in_time = db.Column(db.Time)
    check_out_time = db.Column(db.Time)
    status = db.Column(db.String(20), default="present")
    method = db.Column(db.String(20), default="card")
    remark = db.Column(db.String(200), default="")


class GradeReport(db.Model, SerializerMixin):
    __tablename__ = "grade_report"
    json_fields = {"subjects"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    student_id = db.Column(db.BigInteger, nullable=False, index=True)
    student_name = db.Column(db.String(50), default="")
    class_name = db.Column(db.String(100), default="")
    exam_name = db.Column(db.String(200), nullable=False)
    exam_date = db.Column(db.DateTime, index=True)
    subjects = db.Column(db.Text, default="[]")
    total_score = db.Column(db.Integer, default=0)
    total_full_score = db.Column(db.Integer, default=0)
    class_rank = db.Column(db.Integer, default=0)
    class_size = db.Column(db.Integer, default=0)
    grade_rank = db.Column(db.Integer, default=0)
    grade_size = db.Column(db.Integer, default=0)
    teacher_comment = db.Column(db.String(500), default="")


class HealthRecord(db.Model, SerializerMixin):
    __tablename__ = "health_record"
    json_fields = {"vaccinations"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    student_id = db.Column(db.BigInteger, nullable=False, index=True)
    student_name = db.Column(db.String(50), default="")
    class_name = db.Column(db.String(100), default="")
    record_date = db.Column(db.DateTime, index=True)
    height = db.Column(db.Numeric(5, 2), default=0)
    weight = db.Column(db.Numeric(5, 2), default=0)
    bmi = db.Column(db.Numeric(5, 2), default=0)
    vision_left = db.Column(db.Numeric(5, 2), default=0)
    vision_right = db.Column(db.Numeric(5, 2), default=0)
    temperature = db.Column(db.Numeric(5, 2), default=0)
    blood_pressure = db.Column(db.String(20), default="")
    heart_rate = db.Column(db.Integer, default=0)
    vaccinations = db.Column(db.Text, default="[]")
    medical_history = db.Column(db.String(500), default="")
    allergies = db.Column(db.String(200), default="")
    health_status = db.Column(db.String(20), default="healthy")
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class Evaluation(db.Model, SerializerMixin):
    __tablename__ = "evaluation"
    json_fields = {"tags"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    student_id = db.Column(db.BigInteger, nullable=False, index=True)
    student_name = db.Column(db.String(50), default="")
    student_avatar = db.Column(db.String(500), default="")
    teacher_id = db.Column(db.BigInteger, nullable=False, index=True)
    teacher_name = db.Column(db.String(50), default="")
    teacher_avatar = db.Column(db.String(500), default="")
    type = db.Column(db.String(20), default="daily")
    period_label = db.Column(db.String(100), default="")
    rating = db.Column(db.Integer, default=0)
    tags = db.Column(db.Text, default="[]")
    content = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
