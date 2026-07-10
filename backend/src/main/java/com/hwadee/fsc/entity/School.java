package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("school")
public class School {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;
    private String logo;
    private String description;
    private String address;
    private String phone;
    private String principal;
    private Integer foundedYear;
}
