package com.hwadee.fsc.service;

import com.hwadee.fsc.entity.ClassInfo;
import java.util.List;

public interface ClassService {

    List<ClassInfo> getClassesBySchool(Long schoolId);
}
