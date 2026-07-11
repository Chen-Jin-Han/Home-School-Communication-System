package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.User;
import com.hwadee.fsc.mapper.UserMapper;
import com.hwadee.fsc.dto.RegisterRequest;
import com.hwadee.fsc.security.JwtTokenProvider;
import com.hwadee.fsc.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    @Override
    public AuthService.LoginResult login(String phone, String password) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getPhone, phone);
        User user = userMapper.selectOne(wrapper);

        if (user == null) {
            throw new BusinessException("手机号或密码错误");
        }

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new BusinessException("手机号或密码错误");
        }

        String token = jwtTokenProvider.generateToken(user.getId(), user.getRole());

        return new AuthService.LoginResult(user, token);
    }

    @Override
    public User register(RegisterRequest params) {
        // Check if phone already exists
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getPhone, params.getPhone());
        Long count = userMapper.selectCount(wrapper);
        if (count != null && count > 0) {
            throw new BusinessException("该手机号已被注册");
        }

        // Build user from request
        User user = new User();
        user.setName(params.getName());
        user.setPhone(params.getPhone());
        user.setPassword(passwordEncoder.encode(params.getPassword()));
        user.setRole(params.getRole());
        user.setSchoolId(params.getSchoolId());
        user.setClassId(params.getClassId());

        // Set timestamps
        LocalDateTime now = LocalDateTime.now();
        user.setCreatedAt(now);
        user.setUpdatedAt(now);

        userMapper.insert(user);
        return user;
    }

    @Override
    public void logout() {
        // Stateless logout: client discards the token
        // No server-side action needed with JWT
    }
}
