import { BaseService, ApiResponse } from './BaseService';
import { LoginParams, User } from '../models/UserModel';
import { MockAuth } from '../mock/MockAuth';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';

export interface LoginResult {
  user: User;
  token: string;
}

export class AuthService extends BaseService {
  static async login(params: LoginParams): Promise<ApiResponse<LoginResult>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const account = MockAuth.accounts.find(
        a => a.phone === params.phone && params.password === '123456'
      );
      if (account) {
        const result: LoginResult = {
          user: account,
          token: `mock_token_${account.id}_${Date.now()}`,
        };
        return BaseService.success(result);
      }
      return BaseService.error<LoginResult>(1001, '手机号或密码错误');
    }
    return HttpUtil.post<LoginResult>('/api/auth/login', { phone: params.phone, password: params.password });
  }

  static async logout(): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(null);
    }
    return HttpUtil.post<null>('/api/auth/logout', {});
  }
}
