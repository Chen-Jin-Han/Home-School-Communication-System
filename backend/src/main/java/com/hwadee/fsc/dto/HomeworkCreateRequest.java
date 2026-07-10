package com.hwadee.fsc.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class HomeworkCreateRequest {

    @NotBlank(message = "科目不能为空")
    private String subject;

    @NotBlank(message = "标题不能为空")
    private String title;

    @NotBlank(message = "内容不能为空")
    private String content;

    @NotNull(message = "班级ID不能为空")
    private Long classId;

    @NotNull(message = "截止日期不能为空")
    private LocalDateTime dueDate;
}
