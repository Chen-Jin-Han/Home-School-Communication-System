import { BaseService, ApiResponse } from './BaseService';
import { LoginParams, User } from '../models/UserModel';
import { MockAuth } from '../mock/MockAuth';

export interface LoginResult {
  user: User;
  token: string;
}

export class AuthService extends BaseService {
  static async login(params: LoginParams): Promise<ApiResponse<LoginResult>> {
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

  static async logout(): Promise<ApiResponse<null>> {
    await BaseService.simulateDelay();
    return BaseService.success(null);
  }
}
