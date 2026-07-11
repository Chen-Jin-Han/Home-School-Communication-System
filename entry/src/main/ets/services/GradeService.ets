import { BaseService, ApiResponse } from './BaseService';
import { GradeReport } from '../models/GradeModel';
import { MockGrades } from '../mock/MockGrades';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';

export class GradeService extends BaseService {
  static async getReports(studentId: string): Promise<ApiResponse<GradeReport[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const reports = MockGrades.list
        .filter(r => r.studentId === studentId)
        .sort((a, b) => b.examDate - a.examDate);
      return BaseService.success(reports);
    }
    return HttpUtil.get<GradeReport[]>(`/api/grades/reports?studentId=${studentId}`);
  }

  static async getDetail(reportId: string): Promise<ApiResponse<GradeReport | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockGrades.list.find(r => r.id === reportId));
    }
    return HttpUtil.get<GradeReport | undefined>(`/api/grades/reports/${reportId}`);
  }
}
