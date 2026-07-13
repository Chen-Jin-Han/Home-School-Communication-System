import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Notice, NoticeQuery } from '../models/NoticeModel';
import { MockNotices } from '../mock/MockNotices';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';

export class NoticeService extends BaseService {
  static async getList(query: NoticeQuery): Promise<ApiResponse<PageResult<Notice>>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      let filtered = [...MockNotices.list];

      // Sort: top first, then by date desc
      filtered.sort((a, b) => {
        if (a.isTop !== b.isTop) {
          return a.isTop ? -1 : 1;
        }
        return b.createdAt - a.createdAt;
      });

      if (query.type) {
        filtered = filtered.filter(n => n.type === query.type);
      }
      if (query.keyword) {
        const kw = query.keyword.toLowerCase();
        filtered = filtered.filter(
          n => n.title.toLowerCase().includes(kw) || n.summary.toLowerCase().includes(kw)
        );
      }
      return BaseService.success(BaseService.paginate(filtered, query.page, query.pageSize));
    }
    return HttpUtil.get<PageResult<Notice>>(
      `/api/notices?type=${query.type || ''}&keyword=${query.keyword || ''}&page=${query.page}&pageSize=${query.pageSize}`
    );
  }

  static async getDetail(noticeId: string): Promise<ApiResponse<Notice | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const notice = MockNotices.list.find(n => n.id === noticeId);
      if (notice) {
        const copy: Notice = {
          id: notice.id,
          title: notice.title,
          summary: notice.summary,
          content: notice.content,
          type: notice.type,
          publisherId: notice.publisherId,
          publisherName: notice.publisherName,
          publisherAvatar: notice.publisherAvatar,
          scope: notice.scope,
          scopeTargetId: notice.scopeTargetId,
          attachments: notice.attachments,
          isTop: notice.isTop,
          viewCount: notice.viewCount + 1,
          createdAt: notice.createdAt,
          updatedAt: notice.updatedAt,
        };
        return BaseService.success(copy);
      }
      return BaseService.success(notice);
    }
    return HttpUtil.get<Notice | undefined>(`/api/notices/${noticeId}`);
  }

  static async create(notice: Notice): Promise<ApiResponse<Notice>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockNotices.list.unshift(notice);
      return BaseService.success(notice);
    }
    return HttpUtil.post<Notice>('/api/notices', notice, UserStore.getInstance().authToken);
  }

  static async update(notice: Notice): Promise<ApiResponse<Notice>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const idx = MockNotices.list.findIndex(n => n.id === notice.id);
      if (idx >= 0) {
        MockNotices.list[idx] = notice;
      }
      return BaseService.success(notice);
    }
    return HttpUtil.put<Notice>(`/api/notices/${notice.id}`, notice, UserStore.getInstance().authToken);
  }

  static async delete(noticeId: string): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      MockNotices.list = MockNotices.list.filter(n => n.id !== noticeId);
      return BaseService.success(null);
    }
    return HttpUtil.del<null>(`/api/notices/${noticeId}`, UserStore.getInstance().authToken);
  }
}
