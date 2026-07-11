package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hwadee.fsc.entity.ClassInfo;
import com.hwadee.fsc.mapper.ClassInfoMapper;
import com.hwadee.fsc.service.ClassService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClassServiceImpl implements ClassService {

    private final ClassInfoMapper classInfoMapper;

    @Override
    public List<ClassInfo> getClassesBySchool(Long schoolId) {
        LambdaQueryWrapper<ClassInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ClassInfo::getSchoolId, schoolId);
        wrapper.orderByAsc(ClassInfo::getGrade).orderByAsc(ClassInfo::getName);
        return classInfoMapper.selectList(wrapper);
    }
}
