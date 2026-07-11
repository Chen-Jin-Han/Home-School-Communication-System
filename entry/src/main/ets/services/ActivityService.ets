import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Activity, ActivityComment } from '../models/ActivityModel';
import { MockActivities } from '../mock/MockActivities';
import { Constants } from '../utils/Constants';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';

export class ActivityService extends BaseService {
  static async getList(
    statusFilter?: string,
    page: number = 1
  ): Promise<ApiResponse<PageResult<Activity>>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      let filtered = [...MockActivities.list];
      if (statusFilter && statusFilter !== 'all') {
        filtered = filtered.filter(a => a.status === statusFilter);
      }
      filtered.sort((a, b) => b.createdAt - a.createdAt);
      return BaseService.success(BaseService.paginate(filtered, page, Constants.PAGE_SIZE));
    }
    return HttpUtil.get<PageResult<Activity>>(
      `/api/activities?status=${statusFilter || ''}&page=${page}&pageSize=${Constants.PAGE_SIZE}`
    );
  }

  static async getDetail(activityId: string): Promise<ApiResponse<Activity | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockActivities.list.find(a => a.id === activityId));
    }
    return HttpUtil.get<Activity | undefined>(`/api/activities/${activityId}`);
  }

  static async join(activityId: string): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const act = MockActivities.list.find(a => a.id === activityId);
      if (act) {
        act.participantCount += 1;
      }
      return BaseService.success(null);
    }
    return HttpUtil.post<null>(`/api/activities/${activityId}/join`, undefined, UserStore.getInstance().authToken);
  }

  static async addComment(activityId: string, comment: ActivityComment): Promise<ApiResponse<ActivityComment>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(comment);
    }
    return HttpUtil.post<ActivityComment>(
      `/api/activities/${activityId}/comments`,
      comment,
      UserStore.getInstance().authToken
    );
  }
}
