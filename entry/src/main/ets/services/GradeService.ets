import { BaseService, ApiResponse } from './BaseService';
import { GradeReport } from '../models/GradeModel';
import { MockGrades } from '../mock/MockGrades';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';
import { DateUtil } from '../utils/DateUtil';

export class GradeService extends BaseService {
  static async getReports(studentId?: string): Promise<ApiResponse<GradeReport[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const reports = MockGrades.list
        .filter(r => !studentId || r.studentId === studentId)
        .sort((a, b) => DateUtil.toMillis(b.examDate) - DateUtil.toMillis(a.examDate));
      return BaseService.success(reports);
    }
    const query = studentId ? `?studentId=${studentId}` : '';
    return HttpUtil.get<GradeReport[]>(`/api/grades/reports${query}`, UserStore.getInstance().authToken);
  }

  static async getDetail(reportId: string): Promise<ApiResponse<GradeReport | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockGrades.list.find(r => r.id === reportId));
    }
    return HttpUtil.get<GradeReport | undefined>(`/api/grades/reports/${reportId}`, UserStore.getInstance().authToken);
  }

  static async create(report: GradeReport): Promise<ApiResponse<GradeReport>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(report);
    }
    return HttpUtil.post<GradeReport>('/api/grades/reports', report, UserStore.getInstance().authToken);
  }
}
