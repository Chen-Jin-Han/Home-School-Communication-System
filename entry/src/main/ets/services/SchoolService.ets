import { BaseService, ApiResponse } from './BaseService';
import { School, OrgNode } from '../models/SchoolModel';

export class SchoolService extends BaseService {
  static async getSchoolInfo(schoolId: string): Promise<ApiResponse<School>> {
    await BaseService.simulateDelay();
    const schoolData: School = {
      id: schoolId,
      name: '华德小学',
      logo: '',
      description: '华德小学是一所全日制公办小学，创建于1995年。学校占地面积20000平方米，现有36个教学班，在校学生1500余人，教职工100余人。学校秉承"立德树人"的办学理念，致力于培养德智体美劳全面发展的学生。',
      address: '华德市华德区教育路88号',
      phone: '0512-88888888',
      principal: '王校长',
      foundedYear: 1995,
    };
    return BaseService.success(schoolData);
  }

  static async getOrgTree(_schoolId: string): Promise<ApiResponse<OrgNode>> {
    await BaseService.simulateDelay();
    const grade1Class1: OrgNode = { id: 'c101', name: '一年级(1)班', type: 'class', headTeacherId: 't101' };
    const grade1Class2: OrgNode = { id: 'c102', name: '一年级(2)班', type: 'class', headTeacherId: 't102' };
    const grade2Class1: OrgNode = { id: 'c201', name: '二年级(1)班', type: 'class', headTeacherId: 't201' };
    const grade2Class2: OrgNode = { id: 'c202', name: '二年级(2)班', type: 'class', headTeacherId: 't202' };
    const grade3Class1: OrgNode = { id: 'c001', name: '三年级(2)班', type: 'class', headTeacherId: 't001' };
    const grade3Class2: OrgNode = { id: 'c302', name: '三年级(1)班', type: 'class', headTeacherId: 't302' };

    const grade1Children: OrgNode[] = [grade1Class1, grade1Class2];
    const grade2Children: OrgNode[] = [grade2Class1, grade2Class2];
    const grade3Children: OrgNode[] = [grade3Class1, grade3Class2];

    const grade1: OrgNode = { id: 'grade1', name: '一年级', type: 'grade', children: grade1Children };
    const grade2: OrgNode = { id: 'grade2', name: '二年级', type: 'grade', children: grade2Children };
    const grade3: OrgNode = { id: 'grade3', name: '三年级', type: 'grade', children: grade3Children };

    const orgRoot: OrgNode = {
      id: _schoolId,
      name: '华德小学',
      type: 'school',
      children: [grade1, grade2, grade3],
    };
    return BaseService.success(orgRoot);
  }
}
