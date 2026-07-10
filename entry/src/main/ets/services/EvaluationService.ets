import { BaseService, ApiResponse } from './BaseService';
import { Evaluation } from '../models/EvaluationModel';
import { MockEvaluations } from '../mock/MockEvaluations';

export class EvaluationService extends BaseService {
  static async getList(studentId: string): Promise<ApiResponse<Evaluation[]>> {
    await BaseService.simulateDelay();
    const list = MockEvaluations.list
      .filter(e => e.studentId === studentId)
      .sort((a, b) => b.createdAt - a.createdAt);
    return BaseService.success(list);
  }

  static async create(evaluation: Evaluation): Promise<ApiResponse<Evaluation>> {
    await BaseService.simulateDelay();
    MockEvaluations.list.unshift(evaluation);
    return BaseService.success(evaluation);
  }

  static async update(evaluation: Evaluation): Promise<ApiResponse<Evaluation>> {
    await BaseService.simulateDelay();
    const idx = MockEvaluations.list.findIndex(e => e.id === evaluation.id);
    if (idx >= 0) {
      MockEvaluations.list[idx] = evaluation;
    }
    return BaseService.success(evaluation);
  }
}
