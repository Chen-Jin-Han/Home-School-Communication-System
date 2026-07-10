import { BaseService, ApiResponse } from './BaseService';
import { HealthRecord } from '../models/HealthModel';
import { MockHealth } from '../mock/MockHealth';

export class HealthService extends BaseService {
  static async getRecords(studentId: string): Promise<ApiResponse<HealthRecord[]>> {
    await BaseService.simulateDelay();
    const records = MockHealth.records
      .filter(r => r.studentId === studentId)
      .sort((a, b) => b.recordDate - a.recordDate);
    return BaseService.success(records);
  }

  static async getDetail(recordId: string): Promise<ApiResponse<HealthRecord | undefined>> {
    await BaseService.simulateDelay();
    return BaseService.success(MockHealth.records.find(r => r.id === recordId));
  }
}
