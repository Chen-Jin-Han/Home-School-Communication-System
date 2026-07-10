package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.dto.NoticeQueryRequest;
import com.hwadee.fsc.entity.Notice;
import com.hwadee.fsc.service.NoticeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/notices")
@RequiredArgsConstructor
@Tag(name = "通知公告")
public class NoticeController {

    private final NoticeService noticeService;

    @GetMapping
    @Operation(summary = "获取通知列表")
    public ApiResponse<PageResult<Notice>> list(NoticeQueryRequest req) {
        return ApiResponse.success(noticeService.getList(req.getType(), req.getKeyword(),
                req.getPage() != null ? req.getPage() : 1,
                req.getPageSize() != null ? req.getPageSize() : 20));
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取通知详情")
    public ApiResponse<Notice> detail(@PathVariable Long id) {
        return ApiResponse.success(noticeService.getDetail(id));
    }

    @PostMapping
    @Operation(summary = "发布通知")
    // TODO: @PreAuthorize("hasRole('TEACHER')")
    public ApiResponse<Notice> create(@RequestBody Notice notice) {
        return ApiResponse.success(noticeService.create(notice));
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新通知")
    // TODO: @PreAuthorize("hasRole('TEACHER')")
    public ApiResponse<Notice> update(@PathVariable Long id, @RequestBody Notice notice) {
        notice.setId(id);
        return ApiResponse.success(noticeService.update(notice));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除通知")
    // TODO: @PreAuthorize("hasRole('TEACHER')")
    public ApiResponse<?> delete(@PathVariable Long id) {
        noticeService.delete(id);
        return ApiResponse.success(null);
    }
}
