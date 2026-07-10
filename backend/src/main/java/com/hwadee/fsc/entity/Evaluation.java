package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("evaluation")
public class Evaluation {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long studentId;
    private String studentName;
    private String studentAvatar;
    private Long teacherId;
    private String teacherName;
    private String teacherAvatar;
    private String type;
    private String periodLabel;
    private Integer rating;
    private String tags;
    private String content;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
