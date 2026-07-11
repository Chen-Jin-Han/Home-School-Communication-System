package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.HealthRecord;
import com.hwadee.fsc.mapper.HealthRecordMapper;
import com.hwadee.fsc.service.HealthService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HealthServiceImpl implements HealthService {

    private final HealthRecordMapper healthRecordMapper;

    @Override
    public List<HealthRecord> getRecords(Long studentId) {
        LambdaQueryWrapper<HealthRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HealthRecord::getStudentId, studentId);
        wrapper.orderByDesc(HealthRecord::getRecordDate);
        return healthRecordMapper.selectList(wrapper);
    }

    @Override
    public HealthRecord getDetail(Long recordId) {
        HealthRecord record = healthRecordMapper.selectById(recordId);
        if (record == null) {
            throw new BusinessException("健康记录不存在");
        }
        return record;
    }
}
