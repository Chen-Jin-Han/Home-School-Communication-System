package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.entity.User;
import com.hwadee.fsc.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Tag(name = "用户管理")
public class UserController {

    private final UserService userService;

    @GetMapping("/profile")
    @Operation(summary = "获取个人资料")
    public ApiResponse<User> profile(@RequestHeader("X-User-Id") Long userId) {
        return ApiResponse.success(userService.getProfile(userId));
    }

    @PutMapping("/profile")
    @Operation(summary = "更新个人资料")
    public ApiResponse<User> updateProfile(@RequestHeader("X-User-Id") Long userId,
                                           @RequestBody User user) {
        user.setId(userId);
        return ApiResponse.success(userService.updateProfile(user));
    }

    @GetMapping("/class/{classId}")
    @Operation(summary = "获取班级学生列表")
    public ApiResponse<List<User>> classStudents(@PathVariable Long classId) {
        return ApiResponse.success(userService.getClassStudents(classId));
    }
}
