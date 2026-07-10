package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.Activity;
import com.hwadee.fsc.mapper.ActivityMapper;
import com.hwadee.fsc.service.ActivityService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ActivityServiceImpl implements ActivityService {

    private final ActivityMapper activityMapper;

    @Override
    public PageResult<Activity> getList(String status, int page, int pageSize) {
        LambdaQueryWrapper<Activity> wrapper = new LambdaQueryWrapper<>();

        if (status != null && !status.isEmpty()) {
            wrapper.eq(Activity::getStatus, status);
        }

        wrapper.orderByDesc(Activity::getCreatedAt);

        Page<Activity> p = new Page<>(page, pageSize);
        Page<Activity> result = activityMapper.selectPage(p, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), page, pageSize);
    }

    @Override
    public Activity getDetail(Long id) {
        Activity activity = activityMapper.selectById(id);
        if (activity == null) {
            throw new BusinessException("活动不存在");
        }
        return activity;
    }

    @Override
    public void join(Long activityId) {
        Activity activity = activityMapper.selectById(activityId);
        if (activity == null) {
            throw new BusinessException("活动不存在");
        }

        if (activity.getMaxParticipants() != null && activity.getParticipantCount() != null) {
            if (activity.getParticipantCount() >= activity.getMaxParticipants()) {
                throw new BusinessException("活动参与人数已满");
            }
        }

        // Increment participant count
        int count = activity.getParticipantCount() != null ? activity.getParticipantCount() + 1 : 1;
        activity.setParticipantCount(count);
        activityMapper.updateById(activity);
    }
}
