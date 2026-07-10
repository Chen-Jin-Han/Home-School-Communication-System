import { USE_MOCK, MOCK_DELAY } from './MockConfig';

export interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}

export interface PageResult<T> {
  list: T[];
  total: number;
  page: number;
  pageSize: number;
}

export class BaseService {
  protected static async simulateDelay(): Promise<void> {
    if (USE_MOCK) {
      await new Promise<void>(r => setTimeout(r, MOCK_DELAY));
    }
  }

  protected static success<T>(data: T): ApiResponse<T> {
    return { code: 0, message: 'success', data: data };
  }

  protected static error<T>(code: number, message: string): ApiResponse<T> {
    return { code, message, data: null as T };
  }

  protected static paginate<T>(list: T[], page: number, pageSize: number): PageResult<T> {
    const start = (page - 1) * pageSize;
    const paged = list.slice(start, start + pageSize);
    return { list: paged, total: list.length, page, pageSize };
  }
}
