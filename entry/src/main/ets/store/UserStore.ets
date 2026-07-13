import { User, UserRole } from '../models/UserModel';
import { StorageUtil } from '../utils/StorageUtil';

@Observed
export class UserStore {
  private static _instance: UserStore;

  static getInstance(): UserStore {
    if (!UserStore._instance) {
      UserStore._instance = new UserStore();
    }
    return UserStore._instance;
  }

  isLoggedIn: boolean = false;
  currentUser: User | null = null;
  authToken: string = '';
  unreadChatCount: number = 0;

  private constructor() {
  }

  async init(): Promise<void> {
    const token = await StorageUtil.get<string>('authToken', '');
    const userId = await StorageUtil.get<string>('userId', '');
    const userName = await StorageUtil.get<string>('userName', '');
    const userRole = await StorageUtil.get<string>('userRole', '');
    const userPhone = await StorageUtil.get<string>('userPhone', '');
    const userEmail = await StorageUtil.get<string>('userEmail', '');
    const schoolId = await StorageUtil.get<string>('schoolId', '');
    const schoolName = await StorageUtil.get<string>('schoolName', '');
    const className = await StorageUtil.get<string>('className', '');
    const classId = await StorageUtil.get<string>('classId', '');

    if (token && userId) {
      this.authToken = token;
      this.isLoggedIn = true;
      this.currentUser = {
        id: userId,
        name: userName,
        avatar: '',
        role: userRole as UserRole,
        phone: userPhone,
        email: userEmail || undefined,
        schoolId: schoolId,
        schoolName: schoolName,
        classId: classId || undefined,
        className: className || undefined,
      };
    }
  }

  async login(user: User, token: string): Promise<void> {
    this.isLoggedIn = true;
    this.currentUser = user;
    this.authToken = token;
    await StorageUtil.put('authToken', token);
    await StorageUtil.put('userId', user.id);
    await StorageUtil.put('userName', user.name);
    await StorageUtil.put('userRole', user.role);
    await StorageUtil.put('userPhone', user.phone);
    await StorageUtil.put('userEmail', user.email || '');
    await StorageUtil.put('schoolId', user.schoolId);
    await StorageUtil.put('schoolName', user.schoolName);
    if (user.classId) {
      await StorageUtil.put('classId', user.classId);
    }
    if (user.className) {
      await StorageUtil.put('className', user.className);
    }
  }

  async updateCurrentUser(user: User): Promise<void> {
    this.currentUser = user;
    await StorageUtil.put('userId', user.id);
    await StorageUtil.put('userName', user.name);
    await StorageUtil.put('userRole', user.role);
    await StorageUtil.put('userPhone', user.phone);
    await StorageUtil.put('userEmail', user.email || '');
    await StorageUtil.put('schoolId', user.schoolId);
    await StorageUtil.put('schoolName', user.schoolName);
    if (user.classId) {
      await StorageUtil.put('classId', user.classId);
    }
    if (user.className) {
      await StorageUtil.put('className', user.className);
    }
  }

  async logout(): Promise<void> {
    this.isLoggedIn = false;
    this.currentUser = null;
    this.authToken = '';
    await StorageUtil.remove('authToken');
    await StorageUtil.remove('userId');
    await StorageUtil.remove('userName');
    await StorageUtil.remove('userRole');
    await StorageUtil.remove('userPhone');
    await StorageUtil.remove('userEmail');
    await StorageUtil.remove('schoolId');
    await StorageUtil.remove('schoolName');
    await StorageUtil.remove('classId');
    await StorageUtil.remove('className');
  }

  hasRole(role: UserRole): boolean {
    return this.currentUser?.role === role;
  }

  isStudent(): boolean {
    return this.hasRole(UserRole.STUDENT);
  }

  isParent(): boolean {
    return this.hasRole(UserRole.PARENT);
  }

  isTeacher(): boolean {
    return this.hasRole(UserRole.TEACHER);
  }

  isLeader(): boolean {
    return this.hasRole(UserRole.LEADER);
  }

  getChildId(): string | undefined {
    if (this.isParent() && this.currentUser?.childIds && this.currentUser.childIds.length > 0) {
      return this.currentUser.childIds[0];
    }
    return undefined;
  }

  getStudentId(): string | undefined {
    if (this.isStudent()) {
      return this.currentUser?.id;
    }
    if (this.isParent()) {
      return this.getChildId();
    }
    return undefined;
  }
}
