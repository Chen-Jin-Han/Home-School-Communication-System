package com.hwadee.fsc.service;

import com.hwadee.fsc.entity.User;
import java.util.List;

public interface UserService {

    User getProfile(Long userId);

    User updateProfile(User user);

    List<User> getClassStudents(Long classId);
}
