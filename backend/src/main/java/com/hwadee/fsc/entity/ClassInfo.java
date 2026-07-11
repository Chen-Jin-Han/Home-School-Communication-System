package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("class_info")
public class ClassInfo {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;
    private Integer grade;
    private Long schoolId;
    private Long headTeacherId;
    private String headTeacherName;
    private Integer studentCount;
}
