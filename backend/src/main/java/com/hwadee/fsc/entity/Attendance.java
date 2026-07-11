package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@TableName("attendance")
public class Attendance {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long studentId;
    private String studentName;
    private String studentAvatar;
    private Long classId;
    private String className;
    private LocalDate date;
    private String dayOfWeek;
    private LocalTime checkInTime;
    private LocalTime checkOutTime;
    private String status;
    private String method;
    private String remark;
}
