package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.ClassInfo;
import com.hwadee.fsc.entity.School;
import com.hwadee.fsc.mapper.ClassInfoMapper;
import com.hwadee.fsc.mapper.SchoolMapper;
import com.hwadee.fsc.service.SchoolService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SchoolServiceImpl implements SchoolService {

    private final SchoolMapper schoolMapper;
    private final ClassInfoMapper classInfoMapper;

    @Override
    public School getSchoolInfo(Long schoolId) {
        School school = schoolMapper.selectById(schoolId);
        if (school == null) {
            throw new BusinessException("学校不存在");
        }
        return school;
    }

    @Override
    public Map<String, Object> getOrgTree(Long schoolId) {
        School school = schoolMapper.selectById(schoolId);
        if (school == null) {
            throw new BusinessException("学校不存在");
        }

        // Query all classes for this school
        LambdaQueryWrapper<ClassInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ClassInfo::getSchoolId, schoolId);
        wrapper.orderByAsc(ClassInfo::getGrade).orderByAsc(ClassInfo::getName);
        List<ClassInfo> classes = classInfoMapper.selectList(wrapper);

        // Build org tree structure: school -> grades -> classes
        Map<String, Object> tree = new LinkedHashMap<>();
        tree.put("schoolId", school.getId());
        tree.put("schoolName", school.getName());
        tree.put("schoolLogo", school.getLogo());
        tree.put("description", school.getDescription());

        // Group classes by grade
        Map<Integer, List<ClassInfo>> gradeMap = classes.stream()
                .collect(Collectors.groupingBy(ClassInfo::getGrade, LinkedHashMap::new, Collectors.toList()));

        List<Map<String, Object>> gradeList = new ArrayList<>();
        for (Map.Entry<Integer, List<ClassInfo>> entry : gradeMap.entrySet()) {
            Map<String, Object> gradeNode = new LinkedHashMap<>();
            gradeNode.put("grade", entry.getKey());
            gradeNode.put("gradeLabel", entry.getKey() + "年级");

            List<Map<String, Object>> classList = new ArrayList<>();
            for (ClassInfo clazz : entry.getValue()) {
                Map<String, Object> classNode = new LinkedHashMap<>();
                classNode.put("classId", clazz.getId());
                classNode.put("className", clazz.getName());
                classNode.put("studentCount", clazz.getStudentCount());
                classNode.put("headTeacherId", clazz.getHeadTeacherId());
                classNode.put("headTeacherName", clazz.getHeadTeacherName());
                classList.add(classNode);
            }
            gradeNode.put("classes", classList);
            gradeList.add(gradeNode);
        }

        tree.put("grades", gradeList);
        return tree;
    }
}
