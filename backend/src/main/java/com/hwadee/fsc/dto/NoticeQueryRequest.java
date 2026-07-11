package com.hwadee.fsc.dto;

import lombok.Data;

@Data
public class NoticeQueryRequest {

    private String type;

    private String keyword;

    private Integer page = 1;

    private Integer pageSize = 20;
}
