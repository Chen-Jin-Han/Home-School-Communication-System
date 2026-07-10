import { AttendanceRecord, AttendanceSummary } from '../models/AttendanceModel';

export class MockAttendance {
  static records: AttendanceRecord[] = [
    {
      id: 'at001', studentId: 's001', studentName: '张小伟', studentAvatar: '',
      classId: 'c001', className: '三年级(2)班',
      date: '2026-07-10', dayOfWeek: '周五',
      checkInTime: '07:45', checkOutTime: '16:30',
      status: 'present', method: 'card', remark: '',
    },
    {
      id: 'at002', studentId: 's001', studentName: '张小伟', studentAvatar: '',
      classId: 'c001', className: '三年级(2)班',
      date: '2026-07-09', dayOfWeek: '周四',
      checkInTime: '07:50', checkOutTime: '16:30',
      status: 'present', method: 'card', remark: '',
    },
    {
      id: 'at003', studentId: 's001', studentName: '张小伟', studentAvatar: '',
      classId: 'c001', className: '三年级(2)班',
      date: '2026-07-08', dayOfWeek: '周三',
      checkInTime: '08:05', checkOutTime: '16:30',
      status: 'late', method: 'card', remark: '迟到5分钟',
    },
    {
      id: 'at004', studentId: 's001', studentName: '张小伟', studentAvatar: '',
      classId: 'c001', className: '三年级(2)班',
      date: '2026-07-07', dayOfWeek: '周二',
      checkInTime: '07:42', checkOutTime: '15:00',
      status: 'early', method: 'card', remark: '家长请假提前离校',
    },
    {
      id: 'at005', studentId: 's001', studentName: '张小伟', studentAvatar: '',
      classId: 'c001', className: '三年级(2)班',
      date: '2026-07-06', dayOfWeek: '周一',
      status: 'absent', method: 'manual', remark: '病假，家长已告知',
    },
    {
      id: 'at006', studentId: 's001', studentName: '张小伟', studentAvatar: '',
      classId: 'c001', className: '三年级(2)班',
      date: '2026-07-05', dayOfWeek: '周日',
      status: 'leave', method: 'manual', remark: '',
    },
    {
      id: 'at007', studentId: 's001', studentName: '张小伟', studentAvatar: '',
      classId: 'c001', className: '三年级(2)班',
      date: '2026-07-03', dayOfWeek: '周五',
      checkInTime: '07:40', checkOutTime: '16:30',
      status: 'present', method: 'card', remark: '',
    },
  ];

  static summary: AttendanceSummary = {
    studentId: 's001',
    studentName: '张小伟',
    className: '三年级(2)班',
    period: '2026年7月',
    totalDays: 5,
    presentDays: 2,
    lateDays: 1,
    absentDays: 1,
    leaveDays: 1,
    earlyDays: 0,
  };

  static todayStatus: AttendanceRecord = {
    id: 'at001', studentId: 's001', studentName: '张小伟', studentAvatar: '',
    classId: 'c001', className: '三年级(2)班',
    date: '2026-07-10', dayOfWeek: '周五',
    checkInTime: '07:45', checkOutTime: '',
    status: 'present', method: 'card', remark: '',
  };
}
