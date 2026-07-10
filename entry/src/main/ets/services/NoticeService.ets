import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Notice, NoticeQuery } from '../models/NoticeModel';
import { MockNotices } from '../mock/MockNotices';

export class NoticeService extends BaseService {
  static async getList(query: NoticeQuery): Promise<ApiResponse<PageResult<Notice>>> {
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

  static async getDetail(noticeId: string): Promise<ApiResponse<Notice | undefined>> {
    await BaseService.simulateDelay();
    const notice = MockNotices.list.find(n => n.id === noticeId);
    if (notice) {
      notice.viewCount += 1;
    }
    return BaseService.success(notice);
  }

  static async create(notice: Notice): Promise<ApiResponse<Notice>> {
    await BaseService.simulateDelay();
    MockNotices.list.unshift(notice);
    return BaseService.success(notice);
  }

  static async update(notice: Notice): Promise<ApiResponse<Notice>> {
    await BaseService.simulateDelay();
    const idx = MockNotices.list.findIndex(n => n.id === notice.id);
    if (idx >= 0) {
      MockNotices.list[idx] = notice;
    }
    return BaseService.success(notice);
  }

  static async delete(noticeId: string): Promise<ApiResponse<null>> {
    await BaseService.simulateDelay();
    MockNotices.list = MockNotices.list.filter(n => n.id !== noticeId);
    return BaseService.success(null);
  }
}
