import { BaseService, ApiResponse } from './BaseService';
import { GradeReport } from '../models/GradeModel';
import { MockGrades } from '../mock/MockGrades';

export class GradeService extends BaseService {
  static async getReports(studentId: string): Promise<ApiResponse<GradeReport[]>> {
    await BaseService.simulateDelay();
    const reports = MockGrades.list
      .filter(r => r.studentId === studentId)
      .sort((a, b) => b.examDate - a.examDate);
    return BaseService.success(reports);
  }

  static async getDetail(reportId: string): Promise<ApiResponse<GradeReport | undefined>> {
    await BaseService.simulateDelay();
    return BaseService.success(MockGrades.list.find(r => r.id === reportId));
  }
}
