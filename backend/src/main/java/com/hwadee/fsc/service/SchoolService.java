package com.hwadee.fsc.service;

import com.hwadee.fsc.entity.School;
import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.List;

public interface SchoolService {

    School getSchoolInfo(Long schoolId);

    OrgNode getOrgTree(Long schoolId);

    @Data
    @AllArgsConstructor
    class OrgNode {
        private Long id;
        private String name;
        private String type;
        private List<OrgNode> children;
        private Long headTeacherId;
    }
}
