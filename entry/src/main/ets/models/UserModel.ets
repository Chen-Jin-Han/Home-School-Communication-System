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
  phone: string;
  password: string;
}

export interface RegisterParams {
  phone: string;
  password: string;
  name: string;
  role: UserRole;
  schoolId: string;
  classId?: string;
}
