package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("homework")
public class Homework {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String subject;
    private String title;
    private String content;
    private Long teacherId;
    private String teacherName;
    private Long classId;
    private String className;
    private String attachments;
    private LocalDateTime dueDate;
    private LocalDateTime assignedAt;
    private Integer submissionCount;
    private Integer totalStudents;
    private String status;
}
