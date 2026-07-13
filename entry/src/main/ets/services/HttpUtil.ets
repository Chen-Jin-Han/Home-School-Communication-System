import { http } from '@kit.NetworkKit';
import { router } from '@kit.ArkUI';
import { ApiResponse } from './BaseService';
import { UserStore } from '../store/UserStore';

const DEFAULT_BASE_URL = 'http://8.218.156.55:8080';
const TIMEOUT = 10000;
const LOGIN_ROUTE = 'pages/LoginPage';

export class HttpUtil {
  private static baseUrl: string = DEFAULT_BASE_URL;
  private static handlingUnauthorized: boolean = false;

  static setBaseUrl(url: string): void {
    if (url && url.length > 0) {
      HttpUtil.baseUrl = url;
    }
  }

  static getBaseUrl(): string {
    return HttpUtil.baseUrl;
  }

  static async get<T>(path: string, token?: string): Promise<ApiResponse<T>> {
    return HttpUtil.request<T>(http.RequestMethod.GET, path, undefined, token);
  }

  static async post<T>(path: string, body?: Object, token?: string): Promise<ApiResponse<T>> {
    return HttpUtil.request<T>(http.RequestMethod.POST, path, body, token);
  }

  static async put<T>(path: string, body?: Object, token?: string): Promise<ApiResponse<T>> {
    return HttpUtil.request<T>(http.RequestMethod.PUT, path, body, token);
  }

  static async del<T>(path: string, token?: string): Promise<ApiResponse<T>> {
    return HttpUtil.request<T>(http.RequestMethod.DELETE, path, undefined, token);
  }

  private static async request<T>(
    method: http.RequestMethod,
    path: string,
    body?: Object,
    token?: string
  ): Promise<ApiResponse<T>> {
    const req = http.createHttp();
    try {
      const options: http.HttpRequestOptions = {
        method: method,
        header: HttpUtil.buildHeaders(token),
        connectTimeout: TIMEOUT,
        readTimeout: TIMEOUT,
      };
      if (body !== undefined) {
        options.extraData = JSON.stringify(body);
      }
      const resp = await req.request(HttpUtil.getBaseUrl() + path, options);
      const code = resp.responseCode;

      if (code === 401) {
        HttpUtil.handleUnauthorized();
        return { code: 401, message: '登录已过期，请重新登录', data: null as T };
      }
      if (code >= 400) {
        const msg = HttpUtil.tryMessage(resp.result) || `请求失败(${code})`;
        return { code: code, message: msg, data: null as T };
      }

      return HttpUtil.parse<T>(resp.result);
    } catch (e) {
      console.error(`HttpUtil ${method} ${path} failed:`, e);
      return { code: -1, message: '无法连接服务器，请检查网络', data: null as T };
    } finally {
      req.destroy();
    }
  }

  private static parse<T>(result: string | Object | ArrayBuffer): ApiResponse<T> {
    try {
      if (typeof result === 'string') {
        return JSON.parse(result) as ApiResponse<T>;
      }
      if (result && typeof result === 'object') {
        return result as ApiResponse<T>;
      }
      return { code: -1, message: '服务器返回数据格式异常', data: null as T };
    } catch (e) {
      console.error('HttpUtil parse failed:', e);
      return { code: -1, message: '服务器返回数据解析失败', data: null as T };
    }
  }

  private static tryMessage(result: string | Object | ArrayBuffer): string {
    const parsed = HttpUtil.parse<ApiResponse<null>>(result);
    if (parsed && parsed.message) {
      return parsed.message;
    }
    return '';
  }

  private static handleUnauthorized(): void {
    if (HttpUtil.handlingUnauthorized) {
      return;
    }
    HttpUtil.handlingUnauthorized = true;
    const store = UserStore.getInstance();
    store.logout().finally(() => {
      HttpUtil.handlingUnauthorized = false;
      router.replaceUrl({ url: LOGIN_ROUTE });
    });
  }

  private static buildHeaders(token?: string): Record<string, string> {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    };
    const finalToken = token && token.length > 0 ? token : UserStore.getInstance().authToken;
    if (finalToken && finalToken.length > 0) {
      headers['Authorization'] = `Bearer ${finalToken}`;
    }
    return headers;
  }
}
