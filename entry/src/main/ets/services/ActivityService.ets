import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Activity, ActivityComment, ActivityCommentPayload } from '../models/ActivityModel';
import { MockActivities } from '../mock/MockActivities';
import { Constants } from '../utils/Constants';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';
import { DateUtil } from '../utils/DateUtil';

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
      filtered.sort((a, b) => DateUtil.toMillis(b.createdAt) - DateUtil.toMillis(a.createdAt));
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

  static async getComments(activityId: string): Promise<ApiResponse<ActivityComment[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success([]);
    }
    return HttpUtil.get<ActivityComment[]>(`/api/activities/${activityId}/comments`);
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

  static async addComment(activityId: string, content: string): Promise<ApiResponse<ActivityComment>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const store = UserStore.getInstance();
      const now = Date.now();
      return BaseService.success<ActivityComment>({
        id: `mock_${now}`,
        activityId: activityId,
        userId: store.currentUser?.id || '',
        userName: store.currentUser?.name || '',
        userAvatar: store.currentUser?.avatar || '',
        role: store.currentUser?.role || '',
        content: content,
        createdAt: now,
      });
    }
    const payload: ActivityCommentPayload = { content: content };
    return HttpUtil.post<ActivityComment>(
      `/api/activities/${activityId}/comments`,
      payload,
      UserStore.getInstance().authToken
    );
  }

  static async create(activity: Activity): Promise<ApiResponse<Activity>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockActivities.list.unshift(activity);
      return BaseService.success(activity);
    }
    return HttpUtil.post<Activity>('/api/activities', activity, UserStore.getInstance().authToken);
  }

  static async update(activityId: string, activity: Activity): Promise<ApiResponse<Activity>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const idx = MockActivities.list.findIndex(a => a.id === activityId);
      if (idx >= 0) {
        MockActivities.list[idx] = activity;
      }
      return BaseService.success(activity);
    }
    return HttpUtil.put<Activity>(`/api/activities/${activityId}`, activity, UserStore.getInstance().authToken);
  }

  static async delete(activityId: string): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockActivities.list = MockActivities.list.filter(a => a.id !== activityId);
      return BaseService.success(null);
    }
    return HttpUtil.del<null>(`/api/activities/${activityId}`, UserStore.getInstance().authToken);
  }
}
