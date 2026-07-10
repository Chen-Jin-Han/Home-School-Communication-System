package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("activity")
public class Activity {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;
    private String description;
    private String coverImage;
    private Long organizerId;
    private String organizerName;
    private String location;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer participantCount;
    private Integer maxParticipants;
    private String photos;
    private String status;
    private LocalDateTime createdAt;
}
