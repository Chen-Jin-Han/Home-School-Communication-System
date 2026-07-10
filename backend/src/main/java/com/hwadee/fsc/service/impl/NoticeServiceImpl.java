package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.Notice;
import com.hwadee.fsc.mapper.NoticeMapper;
import com.hwadee.fsc.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {

    private final NoticeMapper noticeMapper;

    @Override
    public PageResult<Notice> getList(String type, String keyword, int page, int pageSize) {
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();

        if (type != null && !type.isEmpty()) {
            wrapper.eq(Notice::getType, type);
        }

        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Notice::getTitle, keyword).or().like(Notice::getSummary, keyword));
        }

        wrapper.orderByDesc(Notice::getIsTop).orderByDesc(Notice::getCreatedAt);

        Page<Notice> p = new Page<>(page, pageSize);
        Page<Notice> result = noticeMapper.selectPage(p, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), page, pageSize);
    }

    @Override
    public Notice getDetail(Long id) {
        Notice notice = noticeMapper.selectById(id);
        if (notice == null) {
            throw new BusinessException("通知不存在");
        }

        // Increment view count
        notice.setViewCount(notice.getViewCount() != null ? notice.getViewCount() + 1 : 1);
        noticeMapper.updateById(notice);

        return notice;
    }

    @Override
    public Notice create(Notice notice) {
        LocalDateTime now = LocalDateTime.now();
        notice.setCreatedAt(now);
        notice.setUpdatedAt(now);
        notice.setViewCount(0);
        notice.setIsTop(notice.getIsTop() != null ? notice.getIsTop() : false);

        noticeMapper.insert(notice);
        return notice;
    }

    @Override
    public Notice update(Notice notice) {
        Notice existing = noticeMapper.selectById(notice.getId());
        if (existing == null) {
            throw new BusinessException("通知不存在");
        }

        notice.setUpdatedAt(LocalDateTime.now());
        noticeMapper.updateById(notice);
        return noticeMapper.selectById(notice.getId());
    }

    @Override
    public void delete(Long id) {
        Notice existing = noticeMapper.selectById(id);
        if (existing == null) {
            throw new BusinessException("通知不存在");
        }
        noticeMapper.deleteById(id);
    }
}
