import { Homework, Submission } from '../models/HomeworkModel';

export class MockHomework {
  static list: Homework[] = [
    {
      id: 'hw001',
      subject: '语文',
      title: '背诵古诗《静夜思》并默写',
      content: '1. 熟读古诗三遍\n2. 理解诗意，背诵全文\n3. 在练习本上默写一遍\n4. 家长签字确认',
      teacherId: 't001',
      teacherName: '李老师',
      classId: 'c001',
      className: '三年级(2)班',
      attachments: [],
      dueDate: Date.now() + 86400000 * 2,
      assignedAt: Date.now() - 86400000,
      submissionCount: 18,
      totalStudents: 40,
      status: 'active',
    } as Homework,
    {
      id: 'hw002',
      subject: '数学',
      title: '完成习题册第45-48页',
      content: '1. 完成课本习题册第45页（应用题1-5题）\n2. 完成第46页（计算题1-10题）\n3. 第47-48页为选做题目\n4. 注意书写工整，列式清晰',
      teacherId: 't002',
      teacherName: '王老师',
      classId: 'c001',
      className: '三年级(2)班',
      attachments: [],
      dueDate: Date.now() + 86400000,
      assignedAt: Date.now() - 86400000 * 2,
      submissionCount: 25,
      totalStudents: 40,
      status: 'active',
    } as Homework,
    {
      id: 'hw003',
      subject: '英语',
      title: '朗读课文Unit 5并完成单词抄写',
      content: '1. 听录音，跟读课文3遍\n2. 抄写新单词每个5遍（共10个单词）\n3. 完成课后练习P56-57',
      teacherId: 't003',
      teacherName: '赵老师',
      classId: 'c001',
      className: '三年级(2)班',
      attachments: [],
      dueDate: Date.now() + 86400000 * 3,
      assignedAt: Date.now() - 86400000 * 0.5,
      submissionCount: 5,
      totalStudents: 40,
      status: 'active',
    } as Homework,
    {
      id: 'hw004',
      subject: '语文',
      title: '阅读《春》并写读后感',
      content: '1. 认真阅读课文《春》\n2. 找出文中描写春天的好词好句（至少5处）\n3. 写一篇200字的读后感',
      teacherId: 't001',
      teacherName: '李老师',
      classId: 'c001',
      className: '三年级(2)班',
      attachments: [],
      dueDate: Date.now() - 86400000 * 2,
      assignedAt: Date.now() - 86400000 * 7,
      submissionCount: 38,
      totalStudents: 40,
      status: 'expired',
    } as Homework,
  ];

  static submissions: Record<string, Submission[]> = {
    'hw001': [
      {
        id: 'sub001', homeworkId: 'hw001', studentId: 's001',
        studentName: '张小伟', studentAvatar: '',
        content: '已完成背诵和默写。', attachments: [],
        submittedAt: Date.now() - 3600000, status: 'submitted',
      } as Submission,
    ] as Submission[],
    'hw002': [
      {
        id: 'sub002', homeworkId: 'hw002', studentId: 's001',
        studentName: '张小伟', studentAvatar: '',
        content: '已完成习题册45-48页。', attachments: [],
        submittedAt: Date.now() - 7200000, score: 95,
        teacherComment: '完成很好，继续加油！', status: 'graded',
      } as Submission,
    ] as Submission[],
    'hw004': [
      {
        id: 'sub003', homeworkId: 'hw004', studentId: 's001',
        studentName: '张小伟', studentAvatar: '',
        content: '《春》读后感：这篇文章描写了春天的美景...', attachments: [],
        submittedAt: Date.now() - 86400000 * 5, score: 88,
        teacherComment: '写出了自己的感受，语言表达可以更丰富一些。', status: 'graded',
      } as Submission,
    ] as Submission[],
  };
}
