package com.hwadee.fsc.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("participant")
public class Participant {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long conversationId;
    private Long userId;
    private String userName;
    private String avatar;
    private String role;
}
