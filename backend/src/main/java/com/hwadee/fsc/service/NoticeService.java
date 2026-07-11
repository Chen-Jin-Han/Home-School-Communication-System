package com.hwadee.fsc.service;

import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.entity.Notice;

public interface NoticeService {

    PageResult<Notice> getList(String type, String keyword, int page, int pageSize);

    Notice getDetail(Long id);

    Notice create(Notice notice);

    Notice update(Notice notice);

    void delete(Long id);
}
