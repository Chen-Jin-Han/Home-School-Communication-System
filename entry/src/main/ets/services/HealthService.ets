import { BaseService, ApiResponse } from './BaseService';
import { HealthRecord } from '../models/HealthModel';
import { MockHealth } from '../mock/MockHealth';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';
import { DateUtil } from '../utils/DateUtil';

export class HealthService extends BaseService {
  static async getRecords(studentId?: string): Promise<ApiResponse<HealthRecord[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      let records = [...MockHealth.records];
      if (studentId) {
        records = records.filter(r => r.studentId === studentId);
      }
      records = records
        .sort((a, b) => DateUtil.toMillis(b.recordDate) - DateUtil.toMillis(a.recordDate));
      return BaseService.success(records);
    }
    const query = studentId ? `?studentId=${studentId}` : '';
    return HttpUtil.get<HealthRecord[]>(`/api/health/records${query}`, UserStore.getInstance().authToken);
  }

  static async getDetail(recordId: string): Promise<ApiResponse<HealthRecord | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockHealth.records.find(r => r.id === recordId));
    }
    return HttpUtil.get<HealthRecord | undefined>(`/api/health/records/${recordId}`, UserStore.getInstance().authToken);
  }

  static async create(record: HealthRecord): Promise<ApiResponse<HealthRecord>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockHealth.records.unshift(record);
      return BaseService.success(record);
    }
    return HttpUtil.post<HealthRecord>('/api/health/records', record, UserStore.getInstance().authToken);
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
    return HttpUtil.put<HealthRecord>(`/api/health/records/${recordId}`, record, UserStore.getInstance().authToken);
  }

  static async delete(recordId: string): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockHealth.records = MockHealth.records.filter(r => r.id !== recordId);
      return BaseService.success(null);
    }
    return HttpUtil.del<null>(`/api/health/records/${recordId}`, UserStore.getInstance().authToken);
  }
}
