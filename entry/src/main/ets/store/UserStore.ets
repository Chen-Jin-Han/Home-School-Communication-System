import { User, UserRole } from '../models/UserModel';
import { StorageUtil } from '../utils/StorageUtil';

const SESSION_KEY = 'user_session';
const VALID_ROLES: string[] = [UserRole.PARENT, UserRole.STUDENT, UserRole.TEACHER, UserRole.LEADER];

interface SessionBlob {
  token: string;
  user: User;
}

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
    const blob = await StorageUtil.getJSON<SessionBlob>(SESSION_KEY);
    if (blob && blob.token && blob.user && blob.user.id) {
      this.authToken = blob.token;
      this.isLoggedIn = true;
      this.currentUser = this.sanitizeUser(blob.user);
    }
  }

  async login(user: User, token: string): Promise<void> {
    this.isLoggedIn = true;
    this.currentUser = this.sanitizeUser(user);
    this.authToken = token;
    await this.persist();
  }

  async updateCurrentUser(user: User): Promise<void> {
    this.currentUser = this.sanitizeUser(user);
    if (this.isLoggedIn) {
      await this.persist();
    }
  }

  async logout(): Promise<void> {
    this.isLoggedIn = false;
    this.currentUser = null;
    this.authToken = '';
    await StorageUtil.remove(SESSION_KEY);
  }

  private async persist(): Promise<void> {
    if (!this.currentUser) {
      return;
    }
    const blob: SessionBlob = { token: this.authToken, user: this.currentUser };
    await StorageUtil.putJSON(SESSION_KEY, blob);
  }

  private sanitizeUser(user: User): User {
    const role: UserRole = VALID_ROLES.includes(user.role as string)
      ? (user.role as UserRole)
      : UserRole.PARENT;
    return {
      id: user.id,
      name: user.name,
      avatar: user.avatar || '',
      role: role,
      phone: user.phone,
      email: user.email || undefined,
      schoolId: user.schoolId,
      schoolName: user.schoolName,
      classId: user.classId || undefined,
      className: user.className || undefined,
      grade: user.grade,
      childIds: user.childIds || [],
      childNames: user.childNames || [],
      subject: user.subject,
      position: user.position,
    };
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

  setUnreadChatCount(count: number): void {
    this.unreadChatCount = count;
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
