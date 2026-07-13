import { BaseService, ApiResponse } from './BaseService';
import { AttendanceRecord, AttendanceSummary } from '../models/AttendanceModel';
import { MockAttendance } from '../mock/MockAttendance';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';

export class AttendanceService extends BaseService {
  static async getRecords(
    studentId: string,
    month?: string
  ): Promise<ApiResponse<AttendanceRecord[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      let records = MockAttendance.records.filter(r => r.studentId === studentId);
      if (month) {
        records = records.filter(r => r.date.startsWith(month));
      }
      records.sort((a, b) => a.date.localeCompare(b.date));
      return BaseService.success(records);
    }
    return HttpUtil.get<AttendanceRecord[]>(
      `/api/attendance/records?studentId=${studentId}&month=${month || ''}`
    );
  }

  static async getTodayStatus(studentId: string): Promise<ApiResponse<AttendanceRecord>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockAttendance.todayStatus);
    }
    return HttpUtil.get<AttendanceRecord>(`/api/attendance/today?studentId=${studentId}`);
  }

  static async getSummary(studentId: string, period: string): Promise<ApiResponse<AttendanceSummary>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockAttendance.summary);
    }
    return HttpUtil.get<AttendanceSummary>(
      `/api/attendance/summary?studentId=${studentId}&period=${period}`
    );
  }

  static async getDetail(recordId: string): Promise<ApiResponse<AttendanceRecord | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockAttendance.records.find(r => r.id === recordId));
    }
    return HttpUtil.get<AttendanceRecord | undefined>(`/api/attendance/records/${recordId}`);
  }

  static async create(record: AttendanceRecord): Promise<ApiResponse<AttendanceRecord>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockAttendance.records.unshift(record);
      return BaseService.success(record);
    }
    return HttpUtil.post<AttendanceRecord>('/api/attendance', record);
  }

  static async update(recordId: string, record: AttendanceRecord): Promise<ApiResponse<AttendanceRecord>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const idx = MockAttendance.records.findIndex(r => r.id === recordId);
      if (idx >= 0) {
        MockAttendance.records[idx] = record;
      }
      return BaseService.success(record);
    }
    return HttpUtil.put<AttendanceRecord>(`/api/attendance/${recordId}`, record);
  }

  static async delete(recordId: string): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockAttendance.records = MockAttendance.records.filter(r => r.id !== recordId);
      return BaseService.success(null);
    }
    return HttpUtil.del<null>(`/api/attendance/${recordId}`);
  }
}
