export enum UserRole {
  PARENT = 'parent',
  STUDENT = 'student',
  TEACHER = 'teacher',
  LEADER = 'leader',
}

export interface User {
  id: string;
  name: string;
  avatar: string;
  role: UserRole;
  phone: string;
  email?: string;
  schoolId: string;
  schoolName: string;
  classId?: string;
  className?: string;
  grade?: number;
  childIds?: string[];
  childNames?: string[];
  subject?: string;
  position?: string;
}

export interface AuthInfo {
  token: string;
  refreshToken: string;
  userId: string;
  expiresAt: number;
}

export interface LoginParams {
  account: string;
  password: string;
  phone?: string;
  email?: string;
}

export interface RegisterParams {
  phone?: string;
  email?: string;
  password: string;
  name: string;
  role: UserRole;
  schoolId: string;
  classId?: string;
}
