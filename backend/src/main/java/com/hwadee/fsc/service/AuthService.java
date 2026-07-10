package com.hwadee.fsc.service;

import com.hwadee.fsc.dto.RegisterRequest;
import com.hwadee.fsc.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;

public interface AuthService {

    LoginResult login(String phone, String password);

    User register(RegisterRequest params);

    void logout();

    @Data
    @AllArgsConstructor
    class LoginResult {
        private User user;
        private String token;
    }
}
