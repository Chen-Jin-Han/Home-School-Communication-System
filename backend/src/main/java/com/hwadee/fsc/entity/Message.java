package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("message")
public class Message {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long conversationId;
    private Long senderId;
    private String senderName;
    private String senderAvatar;
    private String type;
    private String content;
    private Integer duration;
    private LocalDateTime createdAt;
    private String status;
}
