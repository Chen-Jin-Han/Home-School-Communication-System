export interface School {
  id: string;
  name: string;
  logo: string;
  description: string;
  address: string;
  phone: string;
  principal: string;
  foundedYear: number;
}

export interface ClassInfo {
  id: string;
  name: string;
  grade: number;
  schoolId: string;
  headTeacherId: string;
  headTeacherName: string;
  studentCount: number;
}

export interface OrgNode {
  id: string;
  name: string;
  type: 'school' | 'grade' | 'class';
  children?: OrgNode[];
  headTeacherId?: string;
}
