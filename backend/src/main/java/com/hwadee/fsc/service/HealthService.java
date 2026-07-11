package com.hwadee.fsc.service;

import com.hwadee.fsc.entity.HealthRecord;
import java.util.List;

public interface HealthService {

    List<HealthRecord> getRecords(Long studentId);

    HealthRecord getDetail(Long recordId);
}
