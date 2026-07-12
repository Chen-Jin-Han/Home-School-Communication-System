import { BaseService, ApiResponse } from './BaseService';
import { LoginParams, RegisterParams, User } from '../models/UserModel';
import { MockAuth } from '../mock/MockAuth';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';

export interface LoginResult {
  user: User;
  token: string;
}

export class AuthService extends BaseService {
  static async login(params: LoginParams): Promise<ApiResponse<LoginResult>> {
    const accountValue = params.account || params.phone || params.email || '';

    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const account = MockAuth.accounts.find((item: User) => {
        return (item.phone === accountValue || item.email === accountValue) && params.password === '123456';
      });
      if (account) {
        const result: LoginResult = {
          user: account,
          token: `mock_token_${account.id}_${Date.now()}`,
        };
        return BaseService.success(result);
      }
      return BaseService.error<LoginResult>(1001, '账号或密码错误');
    }

    const loginData: LoginParams = {
      account: accountValue,
      phone: accountValue.indexOf('@') >= 0 ? '' : accountValue,
      email: accountValue.indexOf('@') >= 0 ? accountValue : '',
      password: params.password,
    };
    return HttpUtil.post<LoginResult>('/api/auth/login', loginData);
  }

  static async register(params: RegisterParams): Promise<ApiResponse<User>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const newUser: User = {
        id: `u${Date.now()}`,
        name: params.name,
        phone: params.phone || '',
        email: params.email,
        avatar: '',
        role: params.role,
        schoolId: params.schoolId || '',
        schoolName: '华迪小学',
      };
      MockAuth.accounts.push(newUser);
      return BaseService.success(newUser);
    }
    return HttpUtil.post<User>('/api/auth/register', params);
  }

  static async logout(): Promise<ApiResponse<null>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(null);
    }
    return HttpUtil.post<null>('/api/auth/logout');
  }
}
