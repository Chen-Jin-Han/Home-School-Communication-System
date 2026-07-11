import { BaseService, ApiResponse } from './BaseService';
import { HealthRecord } from '../models/HealthModel';
import { MockHealth } from '../mock/MockHealth';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';

export class HealthService extends BaseService {
  static async getRecords(studentId: string): Promise<ApiResponse<HealthRecord[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const records = MockHealth.records
        .filter(r => r.studentId === studentId)
        .sort((a, b) => b.recordDate - a.recordDate);
      return BaseService.success(records);
    }
    return HttpUtil.get<HealthRecord[]>(`/api/health/records?studentId=${studentId}`);
  }

  static async getDetail(recordId: string): Promise<ApiResponse<HealthRecord | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockHealth.records.find(r => r.id === recordId));
    }
    return HttpUtil.get<HealthRecord | undefined>(`/api/health/records/${recordId}`);
  }
}
