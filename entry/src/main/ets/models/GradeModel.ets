export interface SubjectGrade {
  subject: string;
  score: number;
  fullScore: number;
  classAverage: number;
  gradeAverage: number;
  classRank: number;
  gradeRank: number;
  trend: 'up' | 'down' | 'stable';
}

export interface GradeReport {
  id: string;
  studentId: string;
  studentName: string;
  className: string;
  examName: string;
  examDate: number | string;
  subjects: SubjectGrade[];
  totalScore: number;
  totalFullScore: number;
  classRank: number;
  classSize: number;
  gradeRank: number;
  gradeSize: number;
  teacherComment: string;
}
