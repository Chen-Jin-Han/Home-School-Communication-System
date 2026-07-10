package com.hwadee.fsc.service;

import com.hwadee.fsc.entity.GradeReport;
import java.util.List;

public interface GradeService {

    List<GradeReport> getReports(Long studentId);

    GradeReport getDetail(Long reportId);
}
