package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.Evaluation;
import com.hwadee.fsc.mapper.EvaluationMapper;
import com.hwadee.fsc.service.EvaluationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EvaluationServiceImpl implements EvaluationService {

    private final EvaluationMapper evaluationMapper;

    @Override
    public List<Evaluation> getList(Long studentId) {
        LambdaQueryWrapper<Evaluation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Evaluation::getStudentId, studentId);
        wrapper.orderByDesc(Evaluation::getCreatedAt);
        return evaluationMapper.selectList(wrapper);
    }

    @Override
    public Evaluation create(Evaluation evaluation) {
        LocalDateTime now = LocalDateTime.now();
        evaluation.setCreatedAt(now);
        evaluation.setUpdatedAt(now);

        evaluationMapper.insert(evaluation);
        return evaluation;
    }

    @Override
    public Evaluation update(Evaluation evaluation) {
        Evaluation existing = evaluationMapper.selectById(evaluation.getId());
        if (existing == null) {
            throw new BusinessException("评价不存在");
        }

        evaluation.setUpdatedAt(LocalDateTime.now());
        evaluationMapper.updateById(evaluation);
        return evaluationMapper.selectById(evaluation.getId());
    }
}
