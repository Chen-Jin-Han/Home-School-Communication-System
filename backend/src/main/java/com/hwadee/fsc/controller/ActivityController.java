package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.entity.Activity;
import com.hwadee.fsc.service.ActivityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/activities")
@RequiredArgsConstructor
@Tag(name = "校园活动")
public class ActivityController {

    private final ActivityService activityService;

    @GetMapping
    @Operation(summary = "获取活动列表")
    public ApiResponse<PageResult<Activity>> list(@RequestParam(defaultValue = "1") int page,
                                                   @RequestParam(defaultValue = "20") int pageSize) {
        return ApiResponse.success(activityService.getList(page, pageSize));
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取活动详情")
    public ApiResponse<Activity> detail(@PathVariable Long id) {
        return ApiResponse.success(activityService.getDetail(id));
    }

    @PostMapping("/{id}/join")
    @Operation(summary = "报名参加活动")
    public ApiResponse<?> join(@PathVariable Long id,
                               @RequestHeader("X-User-Id") Long userId) {
        activityService.join(id, userId);
        return ApiResponse.success(null);
    }
}
