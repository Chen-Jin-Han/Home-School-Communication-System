import { Attachment } from './NoticeModel';

export interface Homework {
  id: string;
  subject: string;
  title: string;
  content: string;
  teacherId: string;
  teacherName: string;
  classId: string;
  className: string;
  attachments: Attachment[];
  dueDate: number;
  assignedAt: number;
  submissionCount: number;
  totalStudents: number;
  status: 'active' | 'expired';
}

export interface Submission {
  id: string;
  homeworkId: string;
  studentId: string;
  studentName: string;
  studentAvatar: string;
  content: string;
  attachments: Attachment[];
  submittedAt: number;
  score?: number;
  teacherComment?: string;
  status: 'pending' | 'submitted' | 'graded';
}
