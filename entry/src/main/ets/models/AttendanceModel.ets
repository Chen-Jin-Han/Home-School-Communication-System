export type AttendanceStatus = 'present' | 'late' | 'absent' | 'leave' | 'early';
export type CheckMethod = 'card' | 'face' | 'manual';

export interface AttendanceRecord {
  id: string;
  studentId: string;
  studentName: string;
  studentAvatar: string;
  classId: string;
  className: string;
  date: string;
  dayOfWeek: string;
  checkInTime?: string;
  checkOutTime?: string;
  status: AttendanceStatus;
  method: CheckMethod;
  remark: string;
}

export interface AttendanceSummary {
  studentId: string;
  studentName: string;
  className: string;
  period: string;
  totalDays: number;
  presentDays: number;
  lateDays: number;
  absentDays: number;
  leaveDays: number;
  earlyDays: number;
}
