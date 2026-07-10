package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.dto.HomeworkCreateRequest;
import com.hwadee.fsc.dto.SubmissionRequest;
import com.hwadee.fsc.entity.Homework;
import com.hwadee.fsc.entity.Submission;
import com.hwadee.fsc.service.HomeworkService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "作业管理")
public class HomeworkController {

    private final HomeworkService homeworkService;

    @GetMapping("/api/homework")
    @Operation(summary = "获取作业列表")
    public ApiResponse<PageResult<Homework>> list(@RequestParam(defaultValue = "1") int page,
                                                   @RequestParam(defaultValue = "20") int pageSize) {
        return ApiResponse.success(homeworkService.getList(page, pageSize));
    }

    @GetMapping("/api/homework/{id}")
    @Operation(summary = "获取作业详情")
    public ApiResponse<Homework> detail(@PathVariable Long id) {
        return ApiResponse.success(homeworkService.getDetail(id));
    }

    @PostMapping("/api/homework")
    @Operation(summary = "布置作业")
    // TODO: @PreAuthorize("hasRole('TEACHER')")
    public ApiResponse<Homework> create(@RequestHeader("X-User-Id") Long userId,
                                         @Valid @RequestBody HomeworkCreateRequest req) {
        Homework hw = new Homework();
        hw.setSubject(req.getSubject());
        hw.setTitle(req.getTitle());
        hw.setContent(req.getContent());
        hw.setClassId(req.getClassId());
        hw.setDueDate(req.getDueDate());
        hw.setTeacherId(userId);
        return ApiResponse.success(homeworkService.create(hw));
    }

    @GetMapping("/api/homework/{id}/submission")
    @Operation(summary = "获取我的作业提交")
    public ApiResponse<Submission> submission(@PathVariable Long id,
                                              @RequestHeader("X-User-Id") Long userId) {
        return ApiResponse.success(homeworkService.getSubmission(id, userId));
    }

    @PostMapping("/api/homework/{id}/submission")
    @Operation(summary = "提交作业")
    public ApiResponse<Submission> submit(@PathVariable Long id,
                                           @RequestHeader("X-User-Id") Long userId,
                                           @Valid @RequestBody SubmissionRequest req) {
        Submission sub = new Submission();
        sub.setHomeworkId(id);
        sub.setStudentId(userId);
        sub.setContent(req.getContent());
        return ApiResponse.success(homeworkService.submit(sub));
    }

    @PutMapping("/api/submissions/{id}/grade")
    @Operation(summary = "批改作业")
    // TODO: @PreAuthorize("hasRole('TEACHER')")
    public ApiResponse<Submission> grade(@PathVariable Long id,
                                          @RequestParam Integer score,
                                          @RequestParam(required = false) String comment) {
        return ApiResponse.success(homeworkService.grade(id, score, comment));
    }
}
