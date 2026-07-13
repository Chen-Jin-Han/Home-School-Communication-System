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

  static async create(record: HealthRecord): Promise<ApiResponse<HealthRecord>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockHealth.records.unshift(record);
      return BaseService.success(record);
    }
    return HttpUtil.post<HealthRecord>('/api/health/records', record);
  }

  static async update(recordId: string, record: HealthRecord): Promise<ApiResponse<HealthRecord>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const idx = MockHealth.records.findIndex(r => r.id === recordId);
      if (idx >= 0) {
        MockHealth.records[idx] = record;
      }
      return BaseService.success(record);
    }
    return HttpUtil.put<HealthRecord>(`/api/health/records/${recordId}`, record);
  }

  static async delete(recordId: string): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockHealth.records = MockHealth.records.filter(r => r.id !== recordId);
      return BaseService.success(null);
    }
    return HttpUtil.del<null>(`/api/health/records/${recordId}`);
  }
}
