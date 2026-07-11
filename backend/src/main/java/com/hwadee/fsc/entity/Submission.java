package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("submission")
public class Submission {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long homeworkId;
    private Long studentId;
    private String studentName;
    private String studentAvatar;
    private String content;
    private String attachments;
    private LocalDateTime submittedAt;
    private Integer score;
    private String teacherComment;
    private String status;
}
