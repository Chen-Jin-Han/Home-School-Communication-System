package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("health_record")
public class HealthRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long studentId;
    private String studentName;
    private String className;
    private LocalDateTime recordDate;
    private Double height;
    private Double weight;
    private Double bmi;
    private Double visionLeft;
    private Double visionRight;
    private Double temperature;
    private String bloodPressure;
    private Integer heartRate;
    private String vaccinations;
    private String medicalHistory;
    private String allergies;
    private String healthStatus;
    private LocalDateTime updatedAt;
}
