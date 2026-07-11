export type EvaluationPeriod = 'daily' | 'weekly' | 'monthly' | 'semester';

export interface Evaluation {
  id: string;
  studentId: string;
  studentName: string;
  studentAvatar: string;
  teacherId: string;
  teacherName: string;
  teacherAvatar: string;
  type: EvaluationPeriod;
  periodLabel: string;
  rating: number;
  tags: string[];
  content: string;
  createdAt: number;
  updatedAt: number;
}
