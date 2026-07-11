-- H2 Database Init Script (MySQL compatibility mode)

CREATE TABLE IF NOT EXISTS school (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    logo VARCHAR(500) DEFAULT '',
    description TEXT,
    address VARCHAR(200) DEFAULT '',
    phone VARCHAR(20) DEFAULT '',
    principal VARCHAR(50) DEFAULT '',
    founded_year INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS class_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    grade INT DEFAULT 1,
    school_id BIGINT NOT NULL,
    head_teacher_id BIGINT,
    head_teacher_name VARCHAR(50) DEFAULT '',
    student_count INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(200) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'PARENT',
    avatar VARCHAR(500) DEFAULT '',
    school_id BIGINT,
    school_name VARCHAR(100) DEFAULT '',
    class_id BIGINT,
    class_name VARCHAR(100) DEFAULT '',
    grade INT DEFAULT 0,
    child_ids VARCHAR(500) DEFAULT '[]',
    child_names VARCHAR(500) DEFAULT '[]',
    subject VARCHAR(50) DEFAULT '',
    position VARCHAR(50) DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS notice (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    summary VARCHAR(500) DEFAULT '',
    content TEXT,
    type VARCHAR(20) DEFAULT 'notification',
    publisher_id BIGINT NOT NULL,
    publisher_name VARCHAR(50) DEFAULT '',
    publisher_avatar VARCHAR(500) DEFAULT '',
    scope VARCHAR(20) DEFAULT 'all',
    scope_target_id BIGINT,
    attachments TEXT DEFAULT '[]',
    is_top INT DEFAULT 0,
    view_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS conversation (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(20) DEFAULT 'private',
    name VARCHAR(100) DEFAULT '',
    avatar VARCHAR(500) DEFAULT '',
    last_message TEXT DEFAULT '{}',
    unread_count INT DEFAULT 0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS participant (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    conversation_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    user_name VARCHAR(50) DEFAULT '',
    avatar VARCHAR(500) DEFAULT '',
    role VARCHAR(20) DEFAULT ''
);

CREATE TABLE IF NOT EXISTS message (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    conversation_id BIGINT NOT NULL,
    sender_id BIGINT NOT NULL,
    sender_name VARCHAR(50) DEFAULT '',
    sender_avatar VARCHAR(500) DEFAULT '',
    type VARCHAR(20) DEFAULT 'text',
    content TEXT,
    duration INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'sent'
);

CREATE TABLE IF NOT EXISTS homework (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subject VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    teacher_id BIGINT NOT NULL,
    teacher_name VARCHAR(50) DEFAULT '',
    class_id BIGINT NOT NULL,
    class_name VARCHAR(100) DEFAULT '',
    attachments TEXT DEFAULT '[]',
    due_date DATETIME,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    submission_count INT DEFAULT 0,
    total_students INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS submission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    homework_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    student_name VARCHAR(50) DEFAULT '',
    student_avatar VARCHAR(500) DEFAULT '',
    content TEXT,
    attachments TEXT DEFAULT '[]',
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    score INT,
    teacher_comment VARCHAR(500) DEFAULT '',
    status VARCHAR(20) DEFAULT 'submitted'
);

CREATE TABLE IF NOT EXISTS activity (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    cover_image VARCHAR(500) DEFAULT '',
    organizer_id BIGINT NOT NULL,
    organizer_name VARCHAR(50) DEFAULT '',
    location VARCHAR(200) DEFAULT '',
    start_time DATETIME,
    end_time DATETIME,
    participant_count INT DEFAULT 0,
    max_participants INT DEFAULT 0,
    photos TEXT DEFAULT '[]',
    status VARCHAR(20) DEFAULT 'upcoming',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS attendance (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    student_name VARCHAR(50) DEFAULT '',
    student_avatar VARCHAR(500) DEFAULT '',
    class_id BIGINT NOT NULL,
    class_name VARCHAR(100) DEFAULT '',
    date DATE,
    day_of_week VARCHAR(10) DEFAULT '',
    check_in_time TIME,
    check_out_time TIME,
    status VARCHAR(20) DEFAULT 'present',
    method VARCHAR(20) DEFAULT 'card',
    remark VARCHAR(200) DEFAULT ''
);

CREATE TABLE IF NOT EXISTS grade_report (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    student_name VARCHAR(50) DEFAULT '',
    class_name VARCHAR(100) DEFAULT '',
    exam_name VARCHAR(200) NOT NULL,
    exam_date DATETIME,
    subjects TEXT DEFAULT '[]',
    total_score INT DEFAULT 0,
    total_full_score INT DEFAULT 0,
    class_rank INT DEFAULT 0,
    class_size INT DEFAULT 0,
    grade_rank INT DEFAULT 0,
    grade_size INT DEFAULT 0,
    teacher_comment VARCHAR(500) DEFAULT ''
);

CREATE TABLE IF NOT EXISTS health_record (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    student_name VARCHAR(50) DEFAULT '',
    class_name VARCHAR(100) DEFAULT '',
    record_date DATETIME,
    height DECIMAL(5,2) DEFAULT 0,
    weight DECIMAL(5,2) DEFAULT 0,
    bmi DECIMAL(5,2) DEFAULT 0,
    vision_left DECIMAL(5,2) DEFAULT 0,
    vision_right DECIMAL(5,2) DEFAULT 0,
    temperature DECIMAL(5,2) DEFAULT 0,
    blood_pressure VARCHAR(20) DEFAULT '',
    heart_rate INT DEFAULT 0,
    vaccinations TEXT DEFAULT '[]',
    medical_history VARCHAR(500) DEFAULT '',
    allergies VARCHAR(200) DEFAULT '',
    health_status VARCHAR(20) DEFAULT 'healthy',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS evaluation (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    student_name VARCHAR(50) DEFAULT '',
    student_avatar VARCHAR(500) DEFAULT '',
    teacher_id BIGINT NOT NULL,
    teacher_name VARCHAR(50) DEFAULT '',
    teacher_avatar VARCHAR(500) DEFAULT '',
    type VARCHAR(20) DEFAULT 'daily',
    period_label VARCHAR(100) DEFAULT '',
    rating INT DEFAULT 0,
    tags TEXT DEFAULT '[]',
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============ Test Data ============

INSERT INTO school (id, name, description, address, phone, principal, founded_year)
VALUES (1, '华德小学', '华德小学是一所全日制公办小学，创建于1995年', '华德市华德区教育路88号', '0512-88888888', '王校长', 1995);

INSERT INTO class_info (id, name, grade, school_id, head_teacher_id, head_teacher_name, student_count)
VALUES
(1, '一年级(1)班', 1, 1, 3, '李老师', 40),
(2, '三年级(2)班', 3, 1, 3, '李老师', 40),
(3, '五年级(1)班', 5, 1, NULL, '', 35);

INSERT INTO user (id, name, phone, password, role, school_id, school_name, class_id, class_name, grade, child_ids, child_names, subject, position)
VALUES
(1, '张伟', '13800000001', '$2a$10$Kgu4/oUV4guAwgO2bKSxQOl8tw4lM53LN1XPc7rSEGknpjDTS7sFa', 'PARENT', 1, '华德小学', 2, '三年级(2)班', 3, '[2]', '["张小伟"]', '', ''),
(2, '张小伟', '13800000002', '$2a$10$Kgu4/oUV4guAwgO2bKSxQOl8tw4lM53LN1XPc7rSEGknpjDTS7sFa', 'STUDENT', 1, '华德小学', 2, '三年级(2)班', 3, '[]', '[]', '', ''),
(3, '李老师', '13800000003', '$2a$10$Kgu4/oUV4guAwgO2bKSxQOl8tw4lM53LN1XPc7rSEGknpjDTS7sFa', 'TEACHER', 1, '华德小学', 2, '三年级(2)班', 3, '[]', '[]', '语文', ''),
(4, '王校长', '13800000004', '$2a$10$Kgu4/oUV4guAwgO2bKSxQOl8tw4lM53LN1XPc7rSEGknpjDTS7sFa', 'LEADER', 1, '华德小学', NULL, '', 0, '[]', '[]', '', '校长');

INSERT INTO notice (id, title, summary, content, type, publisher_id, publisher_name, scope, is_top, view_count, created_at, updated_at)
VALUES
(1, '关于开展2026年春季运动会的通知', '我校定于2026年4月15日举办春季运动会', '为丰富校园文化生活，增强学生体质，我校定于2026年4月15日-16日在校体育场举办春季运动会。', 'notification', 4, '王校长', 'all', 1, 532, DATEADD('DAY', -2, CURRENT_TIMESTAMP), DATEADD('DAY', -2, CURRENT_TIMESTAMP)),
(2, '三年级语文科组教研活动公告', '本周三下午2点在会议室进行语文教研活动', '本次教研活动主题为阅读教学的创新方法。', 'announcement', 3, '李老师', 'grade', 1, 156, DATEADD('DAY', -3, CURRENT_TIMESTAMP), DATEADD('DAY', -3, CURRENT_TIMESTAMP)),
(3, '华德小学荣获市级文明校园称号', '经市教育局评定，我校被评为2026年度市级文明校园', '经过全体师生的共同努力，我校被市教育局授予市级文明校园荣誉称号。', 'news', 4, '王校长', 'all', 0, 1203, DATEADD('DAY', -5, CURRENT_TIMESTAMP), DATEADD('DAY', -5, CURRENT_TIMESTAMP)),
(4, '关于五一假期安排的通知', '根据国务院放假安排，五一假期5月1日-5月5日', '2026年五一劳动节放假安排：5月1日至5月5日放假调休，共5天。', 'notification', 4, '王校长', 'all', 0, 876, DATEADD('DAY', -7, CURRENT_TIMESTAMP), DATEADD('DAY', -7, CURRENT_TIMESTAMP)),
(5, '三年级（2）班家长会通知', '定于本周五下午3点召开家长会', '主要内容：通报期中考试成绩，讨论班级纪律管理问题。', 'notification', 3, '李老师', 'class', 0, 89, DATEADD('DAY', -1, CURRENT_TIMESTAMP), DATEADD('DAY', -1, CURRENT_TIMESTAMP));

INSERT INTO homework (id, subject, title, content, teacher_id, teacher_name, class_id, class_name, due_date, assigned_at, submission_count, total_students, status)
VALUES
(1, '语文', '背诵古诗《静夜思》并默写', '1. 熟读古诗三遍 2. 理解诗意，背诵全文 3. 在练习本上默写一遍', 3, '李老师', 2, '三年级(2)班', DATEADD('DAY', 2, CURRENT_TIMESTAMP), DATEADD('DAY', -1, CURRENT_TIMESTAMP), 18, 40, 'active'),
(2, '数学', '完成习题册第45-48页', '1. 完成课本习题册第45页应用题 2. 完成第46页计算题', 3, '李老师', 2, '三年级(2)班', DATEADD('DAY', 1, CURRENT_TIMESTAMP), DATEADD('DAY', -2, CURRENT_TIMESTAMP), 25, 40, 'active'),
(3, '英语', '朗读课文Unit 5并完成单词抄写', '1. 听录音跟读课文3遍 2. 抄写新单词每个5遍', 3, '李老师', 2, '三年级(2)班', DATEADD('DAY', 3, CURRENT_TIMESTAMP), CURRENT_TIMESTAMP, 5, 40, 'active');

INSERT INTO grade_report (id, student_id, student_name, class_name, exam_name, exam_date, subjects, total_score, total_full_score, class_rank, class_size, grade_rank, grade_size, teacher_comment)
VALUES
(1, 2, '张小伟', '三年级(2)班', '2026年春季期中考试', DATEADD('DAY', -60, CURRENT_TIMESTAMP), '[{"subject":"语文","score":92,"fullScore":100,"classAvg":85,"gradeAvg":83,"classRank":8,"gradeRank":35,"trend":"up"},{"subject":"数学","score":88,"fullScore":100,"classAvg":82,"gradeAvg":80,"classRank":12,"gradeRank":48,"trend":"stable"},{"subject":"英语","score":95,"fullScore":100,"classAvg":87,"gradeAvg":85,"classRank":5,"gradeRank":20,"trend":"up"}]', 360, 400, 10, 40, 42, 200, '张小伟同学学习认真，语文和英语进步明显。'),
(2, 2, '张小伟', '三年级(2)班', '2026年春季月考（3月）', DATEADD('DAY', -100, CURRENT_TIMESTAMP), '[{"subject":"语文","score":88,"fullScore":100,"classAvg":83,"gradeAvg":82,"classRank":12,"gradeRank":50,"trend":"stable"},{"subject":"数学","score":90,"fullScore":100,"classAvg":84,"gradeAvg":81,"classRank":10,"gradeRank":42,"trend":"up"}]', 356, 400, 12, 40, 48, 200, '整体表现良好，各科成绩均衡。');

INSERT INTO health_record (id, student_id, student_name, class_name, record_date, height, weight, bmi, vision_left, vision_right, temperature, blood_pressure, heart_rate, health_status)
VALUES
(1, 2, '张小伟', '三年级(2)班', DATEADD('DAY', -30, CURRENT_TIMESTAMP), 135, 32, 17.6, 5.0, 5.1, 36.5, '100/65', 85, 'healthy'),
(2, 2, '张小伟', '三年级(2)班', DATEADD('DAY', -180, CURRENT_TIMESTAMP), 130, 29, 17.2, 5.0, 5.0, 36.3, '98/62', 88, 'healthy');

INSERT INTO evaluation (id, student_id, student_name, teacher_id, teacher_name, type, period_label, rating, tags, content, created_at, updated_at)
VALUES
(1, 2, '张小伟', 3, '李老师', 'weekly', '2026年7月第1周', 4, '["积极发言","作业认真","团结同学"]', '张小伟同学本周表现良好，课堂上积极举手回答问题，作业完成质量较高。', DATEADD('DAY', -3, CURRENT_TIMESTAMP), DATEADD('DAY', -3, CURRENT_TIMESTAMP)),
(2, 2, '张小伟', 3, '李老师', 'monthly', '2026年6月', 5, '["学习标兵","表现优异","全面发展"]', '张小伟同学本月综合表现优秀，被评为学习标兵。', DATEADD('DAY', -15, CURRENT_TIMESTAMP), DATEADD('DAY', -15, CURRENT_TIMESTAMP)),
(3, 2, '张小伟', 3, '李老师', 'daily', '2026年7月8日', 3, '["需改进","注意力不集中"]', '今天数学课上注意力不够集中，请家长配合督促。', DATEADD('DAY', -2, CURRENT_TIMESTAMP), DATEADD('DAY', -2, CURRENT_TIMESTAMP));
