import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Activity, ActivityComment } from '../models/ActivityModel';
import { MockActivities } from '../mock/MockActivities';
import { Constants } from '../utils/Constants';

export class ActivityService extends BaseService {
  static async getList(
    statusFilter?: string,
    page: number = 1
  ): Promise<ApiResponse<PageResult<Activity>>> {
    await BaseService.simulateDelay();
    let filtered = [...MockActivities.list];
    if (statusFilter && statusFilter !== 'all') {
      filtered = filtered.filter(a => a.status === statusFilter);
    }
    filtered.sort((a, b) => b.createdAt - a.createdAt);
    return BaseService.success(BaseService.paginate(filtered, page, Constants.PAGE_SIZE));
  }

  static async getDetail(activityId: string): Promise<ApiResponse<Activity | undefined>> {
    await BaseService.simulateDelay();
    return BaseService.success(MockActivities.list.find(a => a.id === activityId));
  }

  static async join(activityId: string): Promise<ApiResponse<null>> {
    await BaseService.simulateDelay();
    const act = MockActivities.list.find(a => a.id === activityId);
    if (act) {
      act.participantCount += 1;
    }
    return BaseService.success(null);
  }

  static async addComment(activityId: string, comment: ActivityComment): Promise<ApiResponse<ActivityComment>> {
    await BaseService.simulateDelay();
    return BaseService.success(comment);
  }
}
