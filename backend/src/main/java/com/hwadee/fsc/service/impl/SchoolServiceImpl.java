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
    public OrgNode getOrgTree(Long schoolId) {
        School school = schoolMapper.selectById(schoolId);
        if (school == null) {
            throw new BusinessException("学校不存在");
        }

        // Query all classes for this school
        LambdaQueryWrapper<ClassInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ClassInfo::getSchoolId, schoolId);
        wrapper.orderByAsc(ClassInfo::getGrade).orderByAsc(ClassInfo::getName);
        List<ClassInfo> classes = classInfoMapper.selectList(wrapper);

        // Group classes by grade
        Map<Integer, List<ClassInfo>> gradeMap = classes.stream()
                .collect(Collectors.groupingBy(ClassInfo::getGrade, LinkedHashMap::new, Collectors.toList()));

        // Build org tree: school -> grades -> classes
        List<OrgNode> gradeNodes = new ArrayList<>();
        for (Map.Entry<Integer, List<ClassInfo>> entry : gradeMap.entrySet()) {
            List<OrgNode> classNodes = new ArrayList<>();
            for (ClassInfo clazz : entry.getValue()) {
                OrgNode classNode = new OrgNode(
                        clazz.getId(),
                        clazz.getName(),
                        "class",
                        Collections.emptyList(),
                        clazz.getHeadTeacherId()
                );
                classNodes.add(classNode);
            }
            OrgNode gradeNode = new OrgNode(
                    entry.getKey().longValue(),
                    entry.getKey() + "年级",
                    "grade",
                    classNodes,
                    null
            );
            gradeNodes.add(gradeNode);
        }

        return new OrgNode(
                school.getId(),
                school.getName(),
                "school",
                gradeNodes,
                null
        );
    }
}
