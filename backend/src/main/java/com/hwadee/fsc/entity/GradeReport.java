package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("grade_report")
public class GradeReport {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long studentId;
    private String studentName;
    private String className;
    private String examName;
    private LocalDateTime examDate;
    private String subjects;
    private Integer totalScore;
    private Integer totalFullScore;
    private Integer classRank;
    private Integer classSize;
    private Integer gradeRank;
    private Integer gradeSize;
    private String teacherComment;
}
