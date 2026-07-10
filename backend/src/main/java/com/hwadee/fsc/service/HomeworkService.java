package com.hwadee.fsc.service;

import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.entity.Homework;
import com.hwadee.fsc.entity.Submission;

public interface HomeworkService {

    PageResult<Homework> getList(int page, int pageSize);

    Homework getDetail(Long id);

    Submission getSubmission(Long hwId, Long stuId);

    Homework create(Homework hw);

    Submission submit(Submission sub);

    Submission grade(Long subId, Integer score, String comment);
}
