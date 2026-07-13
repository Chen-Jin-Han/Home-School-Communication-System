import { BaseService, ApiResponse } from './BaseService';
import { User } from '../models/UserModel';
import { MockAuth } from '../mock/MockAuth';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';

interface AddContactRequest {
  identifier: string;
}

const mockContactIds: string[] = [];

export class UserService extends BaseService {
  static async getProfile(userId: string): Promise<ApiResponse<User | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const user = MockAuth.accounts.find(u => u.id === userId);
      return BaseService.success(user);
    }
    const currentId = UserStore.getInstance().currentUser?.id;
    const path = userId && userId !== currentId
      ? `/api/users/${userId}`
      : '/api/users/profile';
    return HttpUtil.get<User | undefined>(path, UserStore.getInstance().authToken);
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

  static async getContacts(): Promise<ApiResponse<User[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const currentId = UserStore.getInstance().currentUser?.id;
      let contacts: User[];
      if (mockContactIds.length > 0) {
        contacts = MockAuth.accounts.filter(
          u => mockContactIds.includes(u.id) && u.id !== currentId
        );
      } else {
        contacts = MockAuth.accounts.filter(u => u.id !== currentId);
      }
      return BaseService.success(contacts);
    }
    return HttpUtil.get<User[]>('/api/users/contacts', UserStore.getInstance().authToken);
  }

  static async addContact(identifier: string): Promise<ApiResponse<User>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const keyword = identifier.trim();
      const currentId = UserStore.getInstance().currentUser?.id;
      const user = MockAuth.accounts.find(u =>
        u.id === keyword ||
        u.phone === keyword ||
        u.email === keyword
      );
      if (!user) {
        return BaseService.error(1000, '联系人不存在');
      }
      if (user.id === currentId) {
        return BaseService.error(1000, '不能添加自己为联系人');
      }
      if (!mockContactIds.includes(user.id)) {
        mockContactIds.push(user.id);
      }
      return BaseService.success(user);
    }
    const payload: AddContactRequest = {
      identifier: identifier,
    };
    return HttpUtil.post<User>('/api/users/contacts', payload, UserStore.getInstance().authToken);
  }
}
