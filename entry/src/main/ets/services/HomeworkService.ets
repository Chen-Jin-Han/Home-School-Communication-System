import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Homework, Submission } from '../models/HomeworkModel';
import { MockHomework } from '../mock/MockHomework';
import { Constants } from '../utils/Constants';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';

interface GradeData {
  score: number;
  comment: string;
}

export class HomeworkService extends BaseService {
  static async getList(classId?: string, page: number = 1): Promise<ApiResponse<PageResult<Homework>>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      let filtered = [...MockHomework.list];
      if (classId) {
        filtered = filtered.filter(h => h.classId === classId);
      }
      filtered.sort((a, b) => b.assignedAt - a.assignedAt);
      return BaseService.success(BaseService.paginate(filtered, page, Constants.PAGE_SIZE));
    }
    return HttpUtil.get<PageResult<Homework>>(
      `/api/homework?classId=${classId || ''}&page=${page}&pageSize=${Constants.PAGE_SIZE}`
    );
  }

  static async getDetail(homeworkId: string): Promise<ApiResponse<Homework | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockHomework.list.find(h => h.id === homeworkId));
    }
    return HttpUtil.get<Homework | undefined>(`/api/homework/${homeworkId}`);
  }

  static async getSubmission(
    homeworkId: string,
    studentId: string
  ): Promise<ApiResponse<Submission | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const submissionsMap = MockHomework.submissions as Record<string, Submission[]>;
      const subs = submissionsMap[homeworkId] || [];
      return BaseService.success(subs.find(s => s.studentId === studentId));
    }
    return HttpUtil.get<Submission | undefined>(
      `/api/homework/${homeworkId}/submission?studentId=${studentId}`
    );
  }

  static async create(homework: Homework): Promise<ApiResponse<Homework>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockHomework.list.unshift(homework);
      return BaseService.success(homework);
    }
    return HttpUtil.post<Homework>('/api/homework', homework, UserStore.getInstance().authToken);
  }

  static async submit(submission: Submission): Promise<ApiResponse<Submission>> {
    if (USE_MOCK) {
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
    return HttpUtil.post<Submission>(
      `/api/homework/${submission.homeworkId}/submission`,
      submission,
      UserStore.getInstance().authToken
    );
  }

  static async grade(
    submissionId: string,
    score: number,
    comment: string
  ): Promise<ApiResponse<Submission | undefined>> {
    if (USE_MOCK) {
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
    const gradeData: GradeData = { score: score, comment: comment };
    return HttpUtil.put<Submission | undefined>(
      `/api/submissions/${submissionId}/grade`,
      gradeData,
      UserStore.getInstance().authToken
    );
  }

  static async getSubmissions(homeworkId: string): Promise<ApiResponse<Submission[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const submissionsMap = MockHomework.submissions as Record<string, Submission[]>;
      return BaseService.success(submissionsMap[homeworkId] || []);
    }
    return HttpUtil.get<Submission[]>(`/api/homework/${homeworkId}/submissions`);
  }

  static async update(homework: Homework): Promise<ApiResponse<Homework>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const idx = MockHomework.list.findIndex(h => h.id === homework.id);
      if (idx >= 0) {
        MockHomework.list[idx] = homework;
      }
      return BaseService.success(homework);
    }
    return HttpUtil.put<Homework>(`/api/homework/${homework.id}`, homework);
  }

  static async delete(homeworkId: string): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockHomework.list = MockHomework.list.filter(h => h.id !== homeworkId);
      return BaseService.success(null);
    }
    return HttpUtil.del<null>(`/api/homework/${homeworkId}`);
  }
}
