package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.dto.EvaluationCreateRequest;
import com.hwadee.fsc.entity.Evaluation;
import com.hwadee.fsc.service.EvaluationService;
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
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/evaluations")
@RequiredArgsConstructor
@Tag(name = "评价管理")
public class EvaluationController {

    private final EvaluationService evaluationService;

    @GetMapping
    @Operation(summary = "获取评价列表")
    public ApiResponse<List<Evaluation>> list(@RequestHeader("X-User-Id") Long userId) {
        return ApiResponse.success(evaluationService.getList(userId));
    }

    @PostMapping
    @Operation(summary = "创建评价")
    // TODO: @PreAuthorize("hasRole('TEACHER')")
    public ApiResponse<Evaluation> create(@RequestHeader("X-User-Id") Long userId,
                                           @Valid @RequestBody EvaluationCreateRequest req) {
        Evaluation ev = new Evaluation();
        ev.setStudentId(req.getStudentId());
        ev.setTeacherId(userId);
        ev.setType(req.getType());
        ev.setPeriodLabel(req.getPeriodLabel());
        ev.setRating(req.getRating());
        ev.setTags(req.getTags());
        ev.setContent(req.getContent());
        return ApiResponse.success(evaluationService.create(ev));
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新评价")
    // TODO: @PreAuthorize("hasRole('TEACHER')")
    public ApiResponse<Evaluation> update(@PathVariable Long id,
                                           @Valid @RequestBody EvaluationCreateRequest req) {
        Evaluation ev = new Evaluation();
        ev.setId(id);
        ev.setType(req.getType());
        ev.setPeriodLabel(req.getPeriodLabel());
        ev.setRating(req.getRating());
        ev.setTags(req.getTags());
        ev.setContent(req.getContent());
        return ApiResponse.success(evaluationService.update(ev));
    }
}
