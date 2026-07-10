package com.hwadee.fsc.service;

import com.hwadee.fsc.entity.Attendance;
import java.util.List;
import java.util.Map;

public interface AttendanceService {

    List<Attendance> getRecords(Long studentId, String month);

    Attendance getTodayStatus(Long studentId);

    Map<String, Object> getSummary(Long studentId, String month);

    Attendance getDetail(Long id);
}
