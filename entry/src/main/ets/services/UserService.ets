import { BaseService, ApiResponse } from './BaseService';
import { User } from '../models/UserModel';
import { MockAuth } from '../mock/MockAuth';

export class UserService extends BaseService {
  static async getProfile(userId: string): Promise<ApiResponse<User | undefined>> {
    await BaseService.simulateDelay();
    const user = MockAuth.accounts.find(u => u.id === userId);
    return BaseService.success(user);
  }

  static async updateProfile(user: User): Promise<ApiResponse<User>> {
    await BaseService.simulateDelay();
    return BaseService.success(user);
  }

  static async getClassStudents(classId: string): Promise<ApiResponse<User[]>> {
    await BaseService.simulateDelay();
    const students = MockAuth.accounts.filter(
      u => u.classId === classId && u.role === 'student'
    );
    return BaseService.success(students);
  }
}
