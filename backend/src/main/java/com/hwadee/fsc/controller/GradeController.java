package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.entity.GradeReport;
import com.hwadee.fsc.service.GradeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/grades")
@RequiredArgsConstructor
@Tag(name = "成绩管理")
public class GradeController {

    private final GradeService gradeService;

    @GetMapping("/reports")
    @Operation(summary = "获取成绩报告列表")
    public ApiResponse<List<GradeReport>> reports(@RequestHeader("X-User-Id") Long userId) {
        return ApiResponse.success(gradeService.getReports(userId));
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取成绩报告详情")
    public ApiResponse<GradeReport> detail(@PathVariable Long id) {
        return ApiResponse.success(gradeService.getDetail(id));
    }
}
