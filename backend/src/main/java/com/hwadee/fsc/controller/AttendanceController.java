package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.entity.Attendance;
import com.hwadee.fsc.service.AttendanceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/attendance")
@RequiredArgsConstructor
@Tag(name = "考勤打卡")
public class AttendanceController {

    private final AttendanceService attendanceService;

    @GetMapping("/records")
    @Operation(summary = "获取考勤记录")
    public ApiResponse<List<Attendance>> records(@RequestHeader("X-User-Id") Long userId,
                                                  @RequestParam(required = false) String month) {
        return ApiResponse.success(attendanceService.getRecords(userId, month));
    }

    @GetMapping("/today")
    @Operation(summary = "获取今日考勤状态")
    public ApiResponse<Attendance> today(@RequestHeader("X-User-Id") Long userId) {
        return ApiResponse.success(attendanceService.getTodayStatus(userId));
    }

    @GetMapping("/summary")
    @Operation(summary = "获取考勤汇总")
    public ApiResponse<Map<String, Object>> summary(@RequestHeader("X-User-Id") Long userId,
                                                     @RequestParam String month) {
        return ApiResponse.success(attendanceService.getSummary(userId, month));
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取考勤详情")
    public ApiResponse<Attendance> detail(@PathVariable Long id) {
        return ApiResponse.success(attendanceService.getDetail(id));
    }
}
