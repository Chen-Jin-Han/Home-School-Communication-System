package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.Attendance;
import com.hwadee.fsc.mapper.AttendanceMapper;
import com.hwadee.fsc.service.AttendanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AttendanceServiceImpl implements AttendanceService {

    private final AttendanceMapper attendanceMapper;

    @Override
    public List<Attendance> getRecords(Long studentId, String month) {
        LambdaQueryWrapper<Attendance> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Attendance::getStudentId, studentId);

        if (month != null && !month.isEmpty()) {
            // month format: "2026-07" -> filter by date prefix "2026-07-"
            wrapper.likeRight(Attendance::getDate, month + "-");
        }

        wrapper.orderByDesc(Attendance::getDate);
        return attendanceMapper.selectList(wrapper);
    }

    @Override
    public Attendance getTodayStatus(Long studentId) {
        LocalDate today = LocalDate.now();

        LambdaQueryWrapper<Attendance> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Attendance::getStudentId, studentId);
        wrapper.eq(Attendance::getDate, today);

        Attendance attendance = attendanceMapper.selectOne(wrapper);
        if (attendance == null) {
            // Return a default record indicating no attendance today
            Attendance empty = new Attendance();
            empty.setStudentId(studentId);
            empty.setDate(today);
            empty.setStatus("not_checked");
            return empty;
        }

        return attendance;
    }

    @Override
    public Map<String, Object> getSummary(Long studentId, String period) {
        // period format: "2026-07" or "2026-07-01_2026-07-31"
        LambdaQueryWrapper<Attendance> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Attendance::getStudentId, studentId);

        if (period != null && !period.isEmpty()) {
            if (period.contains("_")) {
                // Date range: "2026-07-01_2026-07-31"
                String[] parts = period.split("_");
                if (parts.length == 2) {
                    wrapper.ge(Attendance::getDate, LocalDate.parse(parts[0]));
                    wrapper.le(Attendance::getDate, LocalDate.parse(parts[1]));
                }
            } else {
                // Month: "2026-07"
                wrapper.likeRight(Attendance::getDate, period + "-");
            }
        }

        List<Attendance> records = attendanceMapper.selectList(wrapper);

        int total = records.size();
        long normal = records.stream().filter(r -> "normal".equals(r.getStatus())).count();
        long late = records.stream().filter(r -> "late".equals(r.getStatus())).count();
        long leave = records.stream().filter(r -> "leave".equals(r.getStatus())).count();
        long absent = records.stream().filter(r -> "absent".equals(r.getStatus())).count();

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("total", total);
        summary.put("normal", normal);
        summary.put("late", late);
        summary.put("leave", leave);
        summary.put("absent", absent);

        // Calculate attendance rate
        double rate = total > 0 ? (double) normal / total * 100 : 0;
        summary.put("rate", Math.round(rate * 100.0) / 100.0);

        return summary;
    }

    @Override
    public Attendance getDetail(Long id) {
        Attendance attendance = attendanceMapper.selectById(id);
        if (attendance == null) {
            throw new BusinessException("考勤记录不存在");
        }
        return attendance;
    }
}
