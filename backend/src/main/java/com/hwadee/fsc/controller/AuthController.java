package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.dto.LoginRequest;
import com.hwadee.fsc.dto.RegisterRequest;
import com.hwadee.fsc.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "认证管理")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    @Operation(summary = "登录")
    public ApiResponse<AuthService.LoginResult> login(@Valid @RequestBody LoginRequest req) {
        return ApiResponse.success(authService.login(req.getPhone(), req.getPassword()));
    }

    @PostMapping("/register")
    @Operation(summary = "注册")
    public ApiResponse<?> register(@Valid @RequestBody RegisterRequest req) {
        return ApiResponse.success(authService.register(req));
    }

    @PostMapping("/logout")
    @Operation(summary = "退出登录")
    public ApiResponse<?> logout(@RequestHeader("X-User-Id") Long userId) {
        authService.logout();
        return ApiResponse.success(null);
    }
}
