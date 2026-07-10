package com.hwadee.fsc.service;

import com.hwadee.fsc.entity.Evaluation;
import java.util.List;

public interface EvaluationService {

    List<Evaluation> getList(Long studentId);

    Evaluation create(Evaluation ev);

    Evaluation update(Evaluation ev);
}
