package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.GradeReport;
import com.hwadee.fsc.mapper.GradeReportMapper;
import com.hwadee.fsc.service.GradeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GradeServiceImpl implements GradeService {

    private final GradeReportMapper gradeReportMapper;

    @Override
    public List<GradeReport> getReports(Long studentId) {
        LambdaQueryWrapper<GradeReport> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(GradeReport::getStudentId, studentId);
        wrapper.orderByDesc(GradeReport::getExamDate);
        return gradeReportMapper.selectList(wrapper);
    }

    @Override
    public GradeReport getDetail(Long reportId) {
        GradeReport report = gradeReportMapper.selectById(reportId);
        if (report == null) {
            throw new BusinessException("成绩报告不存在");
        }
        return report;
    }
}
