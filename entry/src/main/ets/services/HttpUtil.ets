import { http } from '@kit.NetworkKit';
import { ApiResponse } from './BaseService';

const BASE_URL = 'http://192.168.54.51:8080';
const TIMEOUT = 10000;

export class HttpUtil {
  static setBaseUrl(url: string): void {
    // allow runtime override
  }

  private static getBaseUrl(): string {
    return BASE_URL;
  }

  static async get<T>(path: string, token?: string): Promise<ApiResponse<T>> {
    const req = http.createHttp();
    try {
      const resp = await req.request(this.getBaseUrl() + path, {
        method: http.RequestMethod.GET,
        header: this.buildHeaders(token),
        connectTimeout: TIMEOUT,
        readTimeout: TIMEOUT,
      });
      return JSON.parse(resp.result as string) as ApiResponse<T>;
    } finally {
      req.destroy();
    }
  }

  static async post<T>(path: string, body: Object, token?: string): Promise<ApiResponse<T>> {
    const req = http.createHttp();
    try {
      const resp = await req.request(this.getBaseUrl() + path, {
        method: http.RequestMethod.POST,
        header: this.buildHeaders(token),
        extraData: JSON.stringify(body),
        connectTimeout: TIMEOUT,
        readTimeout: TIMEOUT,
      });
      return JSON.parse(resp.result as string) as ApiResponse<T>;
    } finally {
      req.destroy();
    }
  }

  static async put<T>(path: string, body: Object, token?: string): Promise<ApiResponse<T>> {
    const req = http.createHttp();
    try {
      const resp = await req.request(this.getBaseUrl() + path, {
        method: http.RequestMethod.PUT,
        header: this.buildHeaders(token),
        extraData: JSON.stringify(body),
        connectTimeout: TIMEOUT,
        readTimeout: TIMEOUT,
      });
      return JSON.parse(resp.result as string) as ApiResponse<T>;
    } finally {
      req.destroy();
    }
  }

  static async del<T>(path: string, token?: string): Promise<ApiResponse<T>> {
    const req = http.createHttp();
    try {
      const resp = await req.request(this.getBaseUrl() + path, {
        method: http.RequestMethod.DELETE,
        header: this.buildHeaders(token),
        connectTimeout: TIMEOUT,
        readTimeout: TIMEOUT,
      });
      return JSON.parse(resp.result as string) as ApiResponse<T>;
    } finally {
      req.destroy();
    }
  }

  private static buildHeaders(token?: string): Record<string, string> {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    return headers;
  }
}
