package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.entity.HealthRecord;
import com.hwadee.fsc.service.HealthService;
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
@RequestMapping("/api/health")
@RequiredArgsConstructor
@Tag(name = "健康管理")
public class HealthController {

    private final HealthService healthService;

    @GetMapping("/records")
    @Operation(summary = "获取健康记录列表")
    public ApiResponse<List<HealthRecord>> records(@RequestHeader("X-User-Id") Long userId) {
        return ApiResponse.success(healthService.getRecords(userId));
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取健康记录详情")
    public ApiResponse<HealthRecord> detail(@PathVariable Long id) {
        return ApiResponse.success(healthService.getDetail(id));
    }
}
