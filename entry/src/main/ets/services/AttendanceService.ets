import { BaseService, ApiResponse } from './BaseService';
import { AttendanceRecord, AttendanceSummary } from '../models/AttendanceModel';
import { MockAttendance } from '../mock/MockAttendance';

export class AttendanceService extends BaseService {
  static async getRecords(
    studentId: string,
    month?: string
  ): Promise<ApiResponse<AttendanceRecord[]>> {
    await BaseService.simulateDelay();
    let records = MockAttendance.records.filter(r => r.studentId === studentId);
    if (month) {
      records = records.filter(r => r.date.startsWith(month));
    }
    records.sort((a, b) => a.date.localeCompare(b.date));
    return BaseService.success(records);
  }

  static async getTodayStatus(studentId: string): Promise<ApiResponse<AttendanceRecord>> {
    await BaseService.simulateDelay();
    return BaseService.success(MockAttendance.todayStatus);
  }

  static async getSummary(studentId: string, period: string): Promise<ApiResponse<AttendanceSummary>> {
    await BaseService.simulateDelay();
    return BaseService.success(MockAttendance.summary);
  }

  static async getDetail(recordId: string): Promise<ApiResponse<AttendanceRecord | undefined>> {
    await BaseService.simulateDelay();
    return BaseService.success(MockAttendance.records.find(r => r.id === recordId));
  }
}
