package com.hwadee.fsc.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class EvaluationCreateRequest {

    @NotNull(message = "学生ID不能为空")
    private Long studentId;

    @NotBlank(message = "评价类型不能为空")
    private String type;

    @NotBlank(message = "评价周期不能为空")
    private String periodLabel;

    @NotNull(message = "评分不能为空")
    private Integer rating;

    private String tags;

    private String content;
}
