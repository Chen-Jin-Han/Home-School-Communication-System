package com.hwadee.fsc.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SubmissionRequest {

    @NotBlank(message = "提交内容不能为空")
    private String content;
}
