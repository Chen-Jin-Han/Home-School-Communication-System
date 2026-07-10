import { BaseService, ApiResponse } from './BaseService';
import { Evaluation } from '../models/EvaluationModel';
import { MockEvaluations } from '../mock/MockEvaluations';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';

export class EvaluationService extends BaseService {
  static async getList(studentId: string): Promise<ApiResponse<Evaluation[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const list = MockEvaluations.list
        .filter(e => e.studentId === studentId)
        .sort((a, b) => b.createdAt - a.createdAt);
      return BaseService.success(list);
    }
    return HttpUtil.get<Evaluation[]>(`/api/evaluations?studentId=${studentId}`);
  }

  static async create(evaluation: Evaluation): Promise<ApiResponse<Evaluation>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockEvaluations.list.unshift(evaluation);
      return BaseService.success(evaluation);
    }
    return HttpUtil.post<Evaluation>('/api/evaluations', evaluation, UserStore.getInstance().authToken);
  }

  static async update(evaluation: Evaluation): Promise<ApiResponse<Evaluation>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const idx = MockEvaluations.list.findIndex(e => e.id === evaluation.id);
      if (idx >= 0) {
        MockEvaluations.list[idx] = evaluation;
      }
      return BaseService.success(evaluation);
    }
    return HttpUtil.put<Evaluation>(`/api/evaluations/${evaluation.id}`, evaluation, UserStore.getInstance().authToken);
  }
}
