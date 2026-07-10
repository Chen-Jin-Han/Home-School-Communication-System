import { GradeReport } from '../models/GradeModel';

export class MockGrades {
  static list: GradeReport[] = [
    {
      id: 'gr001',
      studentId: 's001',
      studentName: '张小伟',
      className: '三年级(2)班',
      examName: '2026年春季期中考试',
      examDate: Date.now() - 86400000 * 60,
      subjects: [
        {
          subject: '语文', score: 92, fullScore: 100,
          classAverage: 85, gradeAverage: 83,
          classRank: 8, gradeRank: 35, trend: 'up',
        },
        {
          subject: '数学', score: 88, fullScore: 100,
          classAverage: 82, gradeAverage: 80,
          classRank: 12, gradeRank: 48, trend: 'stable',
        },
        {
          subject: '英语', score: 95, fullScore: 100,
          classAverage: 87, gradeAverage: 85,
          classRank: 5, gradeRank: 20, trend: 'up',
        },
        {
          subject: '科学', score: 85, fullScore: 100,
          classAverage: 80, gradeAverage: 79,
          classRank: 15, gradeRank: 55, trend: 'down',
        },
      ],
      totalScore: 360,
      totalFullScore: 400,
      classRank: 10,
      classSize: 40,
      gradeRank: 42,
      gradeSize: 200,
      teacherComment: '张小伟同学学习认真，语文和英语进步明显，数学保持稳定，科学科目需要加强实验操作能力的训练。',
    },
    {
      id: 'gr002',
      studentId: 's001',
      studentName: '张小伟',
      className: '三年级(2)班',
      examName: '2026年春季月考（3月）',
      examDate: Date.now() - 86400000 * 100,
      subjects: [
        {
          subject: '语文', score: 88, fullScore: 100,
          classAverage: 83, gradeAverage: 82,
          classRank: 12, gradeRank: 50, trend: 'stable',
        },
        {
          subject: '数学', score: 90, fullScore: 100,
          classAverage: 84, gradeAverage: 81,
          classRank: 10, gradeRank: 42, trend: 'up',
        },
        {
          subject: '英语', score: 90, fullScore: 100,
          classAverage: 85, gradeAverage: 84,
          classRank: 8, gradeRank: 35, trend: 'stable',
        },
        {
          subject: '科学', score: 88, fullScore: 100,
          classAverage: 82, gradeAverage: 80,
          classRank: 12, gradeRank: 48, trend: 'stable',
        },
      ],
      totalScore: 356,
      totalFullScore: 400,
      classRank: 12,
      classSize: 40,
      gradeRank: 48,
      gradeSize: 200,
      teacherComment: '整体表现良好，各科成绩均衡，继续保持。',
    },
    {
      id: 'gr003',
      studentId: 's001',
      studentName: '张小伟',
      className: '三年级(2)班',
      examName: '2025年秋季期末考试',
      examDate: Date.now() - 86400000 * 190,
      subjects: [
        {
          subject: '语文', score: 85, fullScore: 100,
          classAverage: 82, gradeAverage: 81,
          classRank: 15, gradeRank: 60, trend: 'up',
        },
        {
          subject: '数学', score: 82, fullScore: 100,
          classAverage: 80, gradeAverage: 78,
          classRank: 18, gradeRank: 65, trend: 'down',
        },
        {
          subject: '英语', score: 88, fullScore: 100,
          classAverage: 84, gradeAverage: 83,
          classRank: 10, gradeRank: 40, trend: 'stable',
        },
        {
          subject: '科学', score: 90, fullScore: 100,
          classAverage: 83, gradeAverage: 81,
          classRank: 10, gradeRank: 38, trend: 'up',
        },
      ],
      totalScore: 345,
      totalFullScore: 400,
      classRank: 15,
      classSize: 40,
      gradeRank: 55,
      gradeSize: 200,
      teacherComment: '期末考试成绩较上次有进步，希望下学期继续保持良好的学习状态。',
    },
  ];
}
