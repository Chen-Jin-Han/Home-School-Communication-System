package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;
    private String phone;
    @JsonIgnore
    private String password;
    private String role;
    private String avatar;
    private Long schoolId;
    private String schoolName;
    private Long classId;
    private String className;
    private Integer grade;
    private String childIds;
    private String childNames;
    private String subject;
    private String position;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
