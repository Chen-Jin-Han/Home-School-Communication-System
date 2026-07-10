package com.hwadee.fsc.service;

import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.entity.Activity;

public interface ActivityService {

    PageResult<Activity> getList(int page, int pageSize);

    Activity getDetail(Long id);

    void join(Long activityId, Long userId);
}
