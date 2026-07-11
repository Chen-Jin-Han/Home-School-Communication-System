import { BaseService, ApiResponse } from './BaseService';
import { User } from '../models/UserModel';
import { MockAuth } from '../mock/MockAuth';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';

export class UserService extends BaseService {
  static async getProfile(userId: string): Promise<ApiResponse<User | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const user = MockAuth.accounts.find(u => u.id === userId);
      return BaseService.success(user);
    }
    return HttpUtil.get<User | undefined>('/api/users/profile', UserStore.getInstance().authToken);
  }

  static async updateProfile(user: User): Promise<ApiResponse<User>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(user);
    }
    return HttpUtil.put<User>('/api/users/profile', user, UserStore.getInstance().authToken);
  }

  static async getClassStudents(classId: string): Promise<ApiResponse<User[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const students = MockAuth.accounts.filter(
        u => u.classId === classId && u.role === 'student'
      );
      return BaseService.success(students);
    }
    return HttpUtil.get<User[]>(`/api/users/class/${classId}`, UserStore.getInstance().authToken);
  }
}
