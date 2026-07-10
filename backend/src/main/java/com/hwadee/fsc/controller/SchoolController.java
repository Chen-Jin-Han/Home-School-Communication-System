package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.entity.School;
import com.hwadee.fsc.service.SchoolService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/schools")
@RequiredArgsConstructor
@Tag(name = "学校管理")
public class SchoolController {

    private final SchoolService schoolService;

    @GetMapping("/{id}")
    @Operation(summary = "获取学校信息")
    public ApiResponse<School> info(@PathVariable Long id) {
        return ApiResponse.success(schoolService.getSchoolInfo(id));
    }

    @GetMapping("/{id}/org-tree")
    @Operation(summary = "获取学校组织架构树")
    public ApiResponse<SchoolService.OrgNode> orgTree(@PathVariable Long id) {
        return ApiResponse.success(schoolService.getOrgTree(id));
    }
}
