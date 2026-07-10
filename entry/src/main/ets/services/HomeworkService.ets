import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Homework, Submission } from '../models/HomeworkModel';
import { MockHomework } from '../mock/MockHomework';
import { Constants } from '../utils/Constants';

export class HomeworkService extends BaseService {
  static async getList(classId?: string, page: number = 1): Promise<ApiResponse<PageResult<Homework>>> {
    await BaseService.simulateDelay();
    let filtered = [...MockHomework.list];
    if (classId) {
      filtered = filtered.filter(h => h.classId === classId);
    }
    filtered.sort((a, b) => b.assignedAt - a.assignedAt);
    return BaseService.success(BaseService.paginate(filtered, page, Constants.PAGE_SIZE));
  }

  static async getDetail(homeworkId: string): Promise<ApiResponse<Homework | undefined>> {
    await BaseService.simulateDelay();
    return BaseService.success(MockHomework.list.find(h => h.id === homeworkId));
  }

  static async getSubmission(
    homeworkId: string,
    studentId: string
  ): Promise<ApiResponse<Submission | undefined>> {
    await BaseService.simulateDelay();
    const submissionsMap = MockHomework.submissions as Record<string, Submission[]>;
    const subs = submissionsMap[homeworkId] || [];
    return BaseService.success(subs.find(s => s.studentId === studentId));
  }

  static async create(homework: Homework): Promise<ApiResponse<Homework>> {
    await BaseService.simulateDelay();
    MockHomework.list.unshift(homework);
    return BaseService.success(homework);
  }

  static async submit(submission: Submission): Promise<ApiResponse<Submission>> {
    await BaseService.simulateDelay();
    const submissionsMap = MockHomework.submissions as Record<string, Submission[]>;
    const arr = submissionsMap[submission.homeworkId];
    if (!arr) {
      submissionsMap[submission.homeworkId] = [];
    }
    submissionsMap[submission.homeworkId].push(submission);
    const hw = MockHomework.list.find(h => h.id === submission.homeworkId);
    if (hw) {
      hw.submissionCount += 1;
    }
    return BaseService.success(submission);
  }

  static async grade(
    submissionId: string,
    score: number,
    comment: string
  ): Promise<ApiResponse<Submission | undefined>> {
    await BaseService.simulateDelay();
    const submissionsMap = MockHomework.submissions as Record<string, Submission[]>;
    for (const key of Object.keys(submissionsMap)) {
      const subs = submissionsMap[key];
      const sub = subs.find(s => s.id === submissionId);
      if (sub) {
        sub.score = score;
        sub.teacherComment = comment;
        sub.status = 'graded';
        return BaseService.success(sub);
      }
    }
    return BaseService.error(2001, '提交记录未找到');
  }
}
