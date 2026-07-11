-- =============================================
-- Hwadee-FSC 家校通 数据库初始化脚本
-- Version: V1
-- =============================================

-- ----------------------------
-- 1. 学校表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `school` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL COMMENT '学校名称',
    `logo` VARCHAR(500) DEFAULT NULL COMMENT '校徽LOGO',
    `description` TEXT DEFAULT NULL COMMENT '学校简介',
    `address` VARCHAR(200) DEFAULT NULL COMMENT '地址',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
    `principal` VARCHAR(50) DEFAULT NULL COMMENT '校长姓名',
    `founded_year` INT DEFAULT NULL COMMENT '建校年份'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学校表';

-- ----------------------------
-- 2. 用户表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL COMMENT '姓名',
    `phone` VARCHAR(20) NOT NULL COMMENT '手机号',
    `password` VARCHAR(255) NOT NULL COMMENT '密码(BCrypt)',
    `role` VARCHAR(20) NOT NULL COMMENT '角色: PARENT/STUDENT/TEACHER/LEADER',
    `avatar` VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    `school_id` BIGINT DEFAULT NULL COMMENT '学校ID',
    `school_name` VARCHAR(100) DEFAULT NULL COMMENT '学校名称',
    `class_id` BIGINT DEFAULT NULL COMMENT '班级ID',
    `class_name` VARCHAR(100) DEFAULT NULL COMMENT '班级名称',
    `grade` INT DEFAULT NULL COMMENT '年级',
    `child_ids` VARCHAR(500) DEFAULT NULL COMMENT '关联孩子ID(逗号分隔)',
    `child_names` VARCHAR(500) DEFAULT NULL COMMENT '关联孩子姓名',
    `subject` VARCHAR(50) DEFAULT NULL COMMENT '任教科目',
    `position` VARCHAR(50) DEFAULT NULL COMMENT '职务',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_phone` (`phone`),
    INDEX `idx_school_id` (`school_id`),
    INDEX `idx_class_id` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ----------------------------
-- 3. 班级表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `class_info` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL COMMENT '班级名称',
    `grade` INT DEFAULT NULL COMMENT '年级',
    `school_id` BIGINT DEFAULT NULL COMMENT '学校ID',
    `head_teacher_id` BIGINT DEFAULT NULL COMMENT '班主任ID',
    `head_teacher_name` VARCHAR(50) DEFAULT NULL COMMENT '班主任姓名',
    `student_count` INT DEFAULT 0 COMMENT '学生人数',
    INDEX `idx_school_id` (`school_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班级表';

-- ----------------------------
-- 4. 通知公告表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `notice` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(200) NOT NULL COMMENT '标题',
    `summary` VARCHAR(500) DEFAULT NULL COMMENT '摘要',
    `content` TEXT DEFAULT NULL COMMENT '内容',
    `type` VARCHAR(20) DEFAULT 'NOTICE' COMMENT '类型: NOTICE/HOMEWORK/ACTIVITY/HEALTH/EVALUATION',
    `publisher_id` BIGINT DEFAULT NULL COMMENT '发布人ID',
    `publisher_name` VARCHAR(50) DEFAULT NULL COMMENT '发布人姓名',
    `publisher_avatar` VARCHAR(500) DEFAULT NULL COMMENT '发布人头像',
    `scope` VARCHAR(20) DEFAULT 'ALL' COMMENT '范围: ALL/CLASS/GRADE',
    `scope_target_id` BIGINT DEFAULT NULL COMMENT '范围目标ID',
    `attachments` VARCHAR(1000) DEFAULT NULL COMMENT '附件(JSON)',
    `is_top` TINYINT(1) DEFAULT 0 COMMENT '是否置顶',
    `view_count` INT DEFAULT 0 COMMENT '浏览次数',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_type` (`type`),
    INDEX `idx_publisher_id` (`publisher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知公告表';

-- ----------------------------
-- 5. 会话表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `conversation` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `type` VARCHAR(20) NOT NULL COMMENT '类型: PRIVATE/GROUP',
    `name` VARCHAR(100) DEFAULT NULL COMMENT '会话名称',
    `avatar` VARCHAR(500) DEFAULT NULL COMMENT '会话头像',
    `last_message` VARCHAR(500) DEFAULT NULL COMMENT '最后一条消息',
    `unread_count` INT DEFAULT 0 COMMENT '未读消息数',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会话表';

-- ----------------------------
-- 6. 参与人表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `participant` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `conversation_id` BIGINT NOT NULL COMMENT '会话ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `user_name` VARCHAR(50) DEFAULT NULL COMMENT '用户名',
    `avatar` VARCHAR(500) DEFAULT NULL COMMENT '头像',
    `role` VARCHAR(20) DEFAULT NULL COMMENT '角色',
    INDEX `idx_conversation_id` (`conversation_id`),
    INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='参与人表';

-- ----------------------------
-- 7. 消息表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `message` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `conversation_id` BIGINT NOT NULL COMMENT '会话ID',
    `sender_id` BIGINT NOT NULL COMMENT '发送人ID',
    `sender_name` VARCHAR(50) DEFAULT NULL COMMENT '发送人姓名',
    `sender_avatar` VARCHAR(500) DEFAULT NULL COMMENT '发送人头像',
    `type` VARCHAR(20) DEFAULT 'text' COMMENT '消息类型: text/image/voice',
    `content` TEXT DEFAULT NULL COMMENT '消息内容',
    `duration` INT DEFAULT NULL COMMENT '语音时长(秒)',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
    `status` VARCHAR(20) DEFAULT 'sent' COMMENT '状态: sent/delivered/read',
    INDEX `idx_conversation_id` (`conversation_id`),
    INDEX `idx_sender_id` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息表';

-- ----------------------------
-- 8. 作业表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `homework` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `subject` VARCHAR(50) NOT NULL COMMENT '科目',
    `title` VARCHAR(200) NOT NULL COMMENT '作业标题',
    `content` TEXT DEFAULT NULL COMMENT '作业内容',
    `teacher_id` BIGINT NOT NULL COMMENT '教师ID',
    `teacher_name` VARCHAR(50) DEFAULT NULL COMMENT '教师姓名',
    `class_id` BIGINT NOT NULL COMMENT '班级ID',
    `class_name` VARCHAR(100) DEFAULT NULL COMMENT '班级名称',
    `attachments` VARCHAR(1000) DEFAULT NULL COMMENT '附件',
    `due_date` DATETIME DEFAULT NULL COMMENT '截止日期',
    `assigned_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '布置时间',
    `submission_count` INT DEFAULT 0 COMMENT '已提交人数',
    `total_students` INT DEFAULT 0 COMMENT '班级总人数',
    `status` VARCHAR(20) DEFAULT 'ACTIVE' COMMENT '状态: ACTIVE/CLOSED',
    INDEX `idx_teacher_id` (`teacher_id`),
    INDEX `idx_class_id` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业表';

-- ----------------------------
-- 9. 作业提交表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `submission` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `homework_id` BIGINT NOT NULL COMMENT '作业ID',
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名',
    `student_avatar` VARCHAR(500) DEFAULT NULL COMMENT '学生头像',
    `content` TEXT DEFAULT NULL COMMENT '提交内容',
    `attachments` VARCHAR(1000) DEFAULT NULL COMMENT '附件',
    `submitted_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    `score` INT DEFAULT NULL COMMENT '批改分数',
    `teacher_comment` VARCHAR(500) DEFAULT NULL COMMENT '教师评语',
    `status` VARCHAR(20) DEFAULT 'SUBMITTED' COMMENT '状态: SUBMITTED/GRADED/LATE',
    INDEX `idx_homework_id` (`homework_id`),
    INDEX `idx_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业提交表';

-- ----------------------------
-- 10. 校园活动表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `activity` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(200) NOT NULL COMMENT '活动标题',
    `description` TEXT DEFAULT NULL COMMENT '活动描述',
    `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图',
    `organizer_id` BIGINT DEFAULT NULL COMMENT '组织者ID',
    `organizer_name` VARCHAR(50) DEFAULT NULL COMMENT '组织者姓名',
    `location` VARCHAR(200) DEFAULT NULL COMMENT '活动地点',
    `start_time` DATETIME DEFAULT NULL COMMENT '开始时间',
    `end_time` DATETIME DEFAULT NULL COMMENT '结束时间',
    `participant_count` INT DEFAULT 0 COMMENT '报名人数',
    `max_participants` INT DEFAULT NULL COMMENT '最大报名人数',
    `photos` VARCHAR(2000) DEFAULT NULL COMMENT '活动照片(JSON)',
    `status` VARCHAR(20) DEFAULT 'UPCOMING' COMMENT '状态: UPCOMING/ONGOING/ENDED',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='校园活动表';

-- ----------------------------
-- 11. 考勤表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `attendance` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名',
    `student_avatar` VARCHAR(500) DEFAULT NULL COMMENT '学生头像',
    `class_id` BIGINT DEFAULT NULL COMMENT '班级ID',
    `class_name` VARCHAR(100) DEFAULT NULL COMMENT '班级名称',
    `date` DATE NOT NULL COMMENT '日期',
    `day_of_week` VARCHAR(10) DEFAULT NULL COMMENT '星期几',
    `check_in_time` TIME DEFAULT NULL COMMENT '签到时间',
    `check_out_time` TIME DEFAULT NULL COMMENT '签退时间',
    `status` VARCHAR(20) DEFAULT 'NORMAL' COMMENT '状态: NORMAL/LATE/ABSENT/EARLY_LEAVE',
    `method` VARCHAR(20) DEFAULT 'FACE' COMMENT '打卡方式: FACE/CARD/MANUAL',
    `remark` VARCHAR(200) DEFAULT NULL COMMENT '备注',
    INDEX `idx_student_id` (`student_id`),
    INDEX `idx_date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考勤表';

-- ----------------------------
-- 12. 成绩报告表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `grade_report` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名',
    `class_name` VARCHAR(100) DEFAULT NULL COMMENT '班级名称',
    `exam_name` VARCHAR(100) NOT NULL COMMENT '考试名称',
    `exam_date` DATETIME DEFAULT NULL COMMENT '考试日期',
    `subjects` TEXT DEFAULT NULL COMMENT '各科成绩(JSON)',
    `total_score` INT DEFAULT NULL COMMENT '总分',
    `total_full_score` INT DEFAULT NULL COMMENT '满分',
    `class_rank` INT DEFAULT NULL COMMENT '班级排名',
    `class_size` INT DEFAULT NULL COMMENT '班级人数',
    `grade_rank` INT DEFAULT NULL COMMENT '年级排名',
    `grade_size` INT DEFAULT NULL COMMENT '年级人数',
    `teacher_comment` VARCHAR(500) DEFAULT NULL COMMENT '教师评语',
    INDEX `idx_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩报告表';

-- ----------------------------
-- 13. 健康记录表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `health_record` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名',
    `class_name` VARCHAR(100) DEFAULT NULL COMMENT '班级名称',
    `record_date` DATETIME NOT NULL COMMENT '记录日期',
    `height` DECIMAL(5,2) DEFAULT NULL COMMENT '身高(cm)',
    `weight` DECIMAL(5,2) DEFAULT NULL COMMENT '体重(kg)',
    `bmi` DECIMAL(5,2) DEFAULT NULL COMMENT 'BMI指数',
    `vision_left` DECIMAL(5,2) DEFAULT NULL COMMENT '左眼视力',
    `vision_right` DECIMAL(5,2) DEFAULT NULL COMMENT '右眼视力',
    `temperature` DECIMAL(5,2) DEFAULT NULL COMMENT '体温',
    `blood_pressure` VARCHAR(20) DEFAULT NULL COMMENT '血压',
    `heart_rate` INT DEFAULT NULL COMMENT '心率',
    `vaccinations` VARCHAR(500) DEFAULT NULL COMMENT '疫苗接种情况',
    `medical_history` VARCHAR(1000) DEFAULT NULL COMMENT '既往病史',
    `allergies` VARCHAR(500) DEFAULT NULL COMMENT '过敏史',
    `health_status` VARCHAR(50) DEFAULT NULL COMMENT '健康状况',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康记录表';

-- ----------------------------
-- 14. 评价表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `evaluation` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名',
    `student_avatar` VARCHAR(500) DEFAULT NULL COMMENT '学生头像',
    `teacher_id` BIGINT NOT NULL COMMENT '教师ID',
    `teacher_name` VARCHAR(50) DEFAULT NULL COMMENT '教师姓名',
    `teacher_avatar` VARCHAR(500) DEFAULT NULL COMMENT '教师头像',
    `type` VARCHAR(20) NOT NULL COMMENT '类型: DAILY/WEEKLY/MONTHLY/TERM',
    `period_label` VARCHAR(50) DEFAULT NULL COMMENT '周期标签',
    `rating` INT NOT NULL COMMENT '评分(1-5)',
    `tags` VARCHAR(500) DEFAULT NULL COMMENT '标签(逗号分隔)',
    `content` TEXT DEFAULT NULL COMMENT '评价内容',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_student_id` (`student_id`),
    INDEX `idx_teacher_id` (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评价表';

-- =============================================
-- 测试数据
-- BCrypt("123456") = $2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW
-- =============================================

-- 学校
INSERT INTO `school` (`id`, `name`, `description`, `address`, `phone`, `principal`, `founded_year`) VALUES
(1, '华德小学', '华德小学是一所历史悠久、环境优美的全日制公办小学，致力于为学生提供优质的基础教育。', '北京市朝阳区华德路100号', '010-88886666', '王校长', 1998);

-- 班级
INSERT INTO `class_info` (`id`, `name`, `grade`, `school_id`, `head_teacher_id`, `head_teacher_name`, `student_count`) VALUES
(1, '一年级1班', 1, 1, 3, '李老师', 42),
(2, '三年级2班', 3, 1, 3, '李老师', 38),
(3, '五年级1班', 5, 1, 3, '李老师', 40);

-- 用户 (密码均为 "123456")
INSERT INTO `user` (`id`, `name`, `phone`, `password`, `role`, `school_id`, `school_name`, `class_id`, `class_name`, `grade`, `child_ids`, `child_names`, `subject`, `position`) VALUES
(1, '张爸爸', '13800000001', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'PARENT', 1, '华德小学', NULL, NULL, NULL, '2', '张小华', NULL, NULL),
(2, '张小华', '13800000002', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'STUDENT', 1, '华德小学', 1, '一年级1班', 1, NULL, NULL, NULL, NULL),
(3, '李老师', '13800000003', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'TEACHER', 1, '华德小学', NULL, NULL, NULL, NULL, NULL, '语文', '班主任'),
(4, '王校长', '13800000004', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'LEADER', 1, '华德小学', NULL, NULL, NULL, NULL, NULL, NULL, '校长');

-- 通知公告 (5条)
INSERT INTO `notice` (`id`, `title`, `summary`, `content`, `type`, `publisher_id`, `publisher_name`, `scope`, `is_top`, `view_count`) VALUES
(1, '关于做好2026年春季学期开学工作的通知', '新学期即将开始，请各位家长和同学做好准备', '<p>尊敬的各位家长、亲爱的同学们：</p><p>2026年春季学期将于2月20日正式开学，现将相关事项通知如下：</p><p>1. 报到时间：2月19日 上午8:00-11:30</p><p>2. 报到地点：各班教室</p><p>3. 携带材料：寒假作业、学生成长手册</p><p>请各位家长提前安排好时间，准时带孩子到校报到。</p>', 'NOTICE', 4, '王校长', 'ALL', 1, 256),
(2, '一年级1班家长会通知', '下周五召开家长会，请准时参加', '<p>各位家长：</p><p>为进一步加强家校沟通，定于下周五（3月15日）下午2:00在本班教室召开家长会，请各位家长准时参加。</p><p>会议主要内容：</p><p>1. 本学期教学计划通报</p><p>2. 学生在校情况反馈</p><p>3. 家校共育交流</p>', 'NOTICE', 3, '李老师', 'CLASS', 0, 42),
(3, '关于开展校园安全演练的通知', '为进一步增强师生安全意识，学校决定开展安全演练', '<p>全校师生：</p><p>为提高师生应急避险能力，学校决定3月20日下午开展消防和地震安全演练。请全体师生按照应急预案要求，有序参与演练。</p><p>注意事项：</p><p>1. 演练前各班班主任须做好安全教育</p><p>2. 演练时听从统一指挥</p><p>3. 如遇身体不适请提前告知老师</p>', 'NOTICE', 4, '王校长', 'ALL', 0, 189),
(4, '春季运动会报名通知', '2026年春季运动会将于4月举行，欢迎同学们踊跃报名', '<p>亲爱的同学们：</p><p>一年一度的春季运动会即将到来！本次运动会设有跑步、跳远、跳高、接力赛、拔河等多个项目。请有意参加的同学于3月25日前到班主任处报名。</p><p>比赛时间：4月10日-4月12日</p><p>比赛地点：学校运动场</p>', 'ACTIVITY', 3, '李老师', 'ALL', 0, 156),
(5, '五一劳动节放假通知', '根据国家规定安排五一假期', '<p>各位家长：</p><p>根据国务院办公厅通知精神，2026年五一劳动节放假安排如下：</p><p>5月1日（周四）至5月5日（周一）放假调休，共5天。4月27日（周日）正常上课（补周四课程）。</p><p>请各位家长做好假期安排，注意学生假期安全。</p>', 'NOTICE', 4, '王校长', 'ALL', 1, 320);

-- 会话 (2条)
INSERT INTO `conversation` (`id`, `type`, `name`, `last_message`, `unread_count`) VALUES
(1, 'GROUP', '一年级1班家校群', '李老师：各位家长，明天请提醒孩子带好绘画工具', 3),
(2, 'PRIVATE', NULL, '张爸爸：李老师您好，我想了解一下小华最近的表现', 1);

-- 参与人
INSERT INTO `participant` (`id`, `conversation_id`, `user_id`, `user_name`, `role`) VALUES
(1, 1, 1, '张爸爸', 'PARENT'),
(2, 1, 3, '李老师', 'TEACHER'),
(3, 2, 1, '张爸爸', 'PARENT'),
(4, 2, 3, '李老师', 'TEACHER');

-- 作业 (3条)
INSERT INTO `homework` (`id`, `subject`, `title`, `content`, `teacher_id`, `teacher_name`, `class_id`, `class_name`, `due_date`, `total_students`, `status`) VALUES
(1, '语文', '背诵古诗《静夜思》', '请同学们背诵李白的《静夜思》，并默写一遍。明天上课检查。', 3, '李老师', 1, '一年级1班', '2026-07-12 23:59:59', 42, 'ACTIVE'),
(2, '语文', '作文：我的梦想', '请以"我的梦想"为题写一篇500字的作文。要求内容充实，条理清晰，语句通顺。', 3, '李老师', 3, '五年级1班', '2026-07-15 23:59:59', 40, 'ACTIVE'),
(3, '语文', '阅读《小王子》第一章', '请阅读《小王子》第一章，完成以下任务：1. 概括第一章的主要内容 2. 找出文中描述作者童年画作的段落 3. 写一段自己的童年趣事（不少于100字）', 3, '李老师', 2, '三年级2班', '2026-07-11 23:59:59', 38, 'ACTIVE');

-- 成绩报告 (2条)
INSERT INTO `grade_report` (`id`, `student_id`, `student_name`, `class_name`, `exam_name`, `exam_date`, `subjects`, `total_score`, `total_full_score`, `class_rank`, `class_size`, `grade_rank`, `grade_size`, `teacher_comment`) VALUES
(1, 2, '张小华', '一年级1班', '2026年春季学期期中考试', '2026-04-20 08:00:00', '[{"subject":"语文","score":95,"fullScore":100},{"subject":"数学","score":98,"fullScore":100},{"subject":"英语","score":92,"fullScore":100}]', 285, 300, 3, 42, 12, 280, '张小华同学学习认真，成绩优秀，继续保持！'),
(2, 2, '张小华', '一年级1班', '2026年春季学期期末考试', '2026-06-25 08:00:00', '[{"subject":"语文","score":97,"fullScore":100},{"subject":"数学","score":100,"fullScore":100},{"subject":"英语","score":95,"fullScore":100}]', 292, 300, 2, 42, 8, 280, '本学期进步明显，数学满分，值得表扬！希望继续努力。');

-- 健康记录 (2条)
INSERT INTO `health_record` (`id`, `student_id`, `student_name`, `class_name`, `record_date`, `height`, `weight`, `bmi`, `vision_left`, `vision_right`, `temperature`, `blood_pressure`, `heart_rate`, `vaccinations`, `health_status`) VALUES
(1, 2, '张小华', '一年级1班', '2026-03-01 09:00:00', 125.50, 25.00, 15.87, 5.0, 5.0, 36.5, '90/60', 85, '已完成国家规定疫苗接种', '健康'),
(2, 2, '张小华', '一年级1班', '2026-06-01 09:00:00', 128.00, 26.50, 16.17, 4.9, 5.0, 36.6, '90/60', 82, '已完成国家规定疫苗接种', '健康');

-- 评价 (3条)
INSERT INTO `evaluation` (`id`, `student_id`, `student_name`, `teacher_id`, `teacher_name`, `type`, `period_label`, `rating`, `tags`, `content`) VALUES
(1, 2, '张小华', 3, '李老师', 'WEEKLY', '2026年第10周', 5, '认真听讲,积极发言,作业工整', '张小华同学本周表现优秀，上课认真听讲，积极举手发言，作业完成质量高。尤其在语文课上朗读课文非常有感情，值得大家学习。'),
(2, 2, '张小华', 3, '李老师', 'MONTHLY', '2026年3月', 4, '遵守纪律,团结同学,进步明显', '本月张小华同学整体表现良好，在课堂纪律方面有进步，与同学相处融洽。数学成绩提升明显，希望能继续保持。建议多参加课外阅读活动。'),
(3, 2, '张小华', 3, '李老师', 'TERM', '2026年春季学期', 5, '全面发展,品学兼优,乐于助人', '张小华同学本学期表现优异，德智体美劳全面发展。学习成绩名列前茅，担任班长工作认真负责，是老师的好帮手。积极参加学校运动会并取得好成绩。');
