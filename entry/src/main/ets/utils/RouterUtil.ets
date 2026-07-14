import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { UserRole } from '../models/UserModel';
import { UserStore } from '../store/UserStore';

export class RouterUtil {
  static back(): void {
    router.back();
  }

  static toLogin(): void {
    router.replaceUrl({ url: 'pages/LoginPage' });
  }

  static toRegister(): void {
    router.pushUrl({ url: 'pages/RegisterPage' });
  }

  static toHome(role: UserRole): void {
    const urls: Record<UserRole, string> = {
      [UserRole.PARENT]: 'pages/home/ParentHomePage',
      [UserRole.STUDENT]: 'pages/home/StudentHomePage',
      [UserRole.TEACHER]: 'pages/home/TeacherHomePage',
      [UserRole.LEADER]: 'pages/home/LeaderHomePage',
    };
    router.replaceUrl({ url: urls[role] });
  }

  static toHomeFromSplash(): void {
    const store = UserStore.getInstance();
    if (store.currentUser) {
      RouterUtil.toHome(store.currentUser.role);
    } else {
      RouterUtil.toLogin();
    }
  }

  static toSchoolInfo(): void {
    router.pushUrl({ url: 'pages/school/SchoolInfoPage' });
  }

  static toNotificationList(): void {
    router.pushUrl({ url: 'pages/school/NotificationListPage' });
  }

  static toNotificationDetail(noticeId: string): void {
    router.pushUrl({ url: 'pages/school/NotificationDetailPage', params: { noticeId } });
  }

  static toPersonalProfile(): void {
    router.pushUrl({ url: 'pages/user/PersonalProfilePage' });
  }

  static toOrgStructure(): void {
    router.pushUrl({ url: 'pages/user/OrgStructurePage' });
  }

  static toStudentList(classId?: string): void {
    router.pushUrl({ url: 'pages/user/StudentListPage', params: { classId } });
  }

  static toPublishNotice(): void {
    const store = UserStore.getInstance();
    if (!store.isTeacher() && !store.isLeader()) {
      promptAction.openToast({ message: '仅教师和领导可发布通知' });
      return;
    }
    router.pushUrl({ url: 'pages/publish/PublishNoticePage' });
  }

  static toMyPublished(): void {
    router.pushUrl({ url: 'pages/publish/MyPublishedPage' });
  }

  static toConversationList(): void {
    router.pushUrl({ url: 'pages/chat/ConversationListPage' });
  }

  static toChat(conversationId: string, name: string): void {
    router.pushUrl({ url: 'pages/chat/ChatPage', params: { conversationId, name } });
  }

  static toSelectContact(): void {
    router.pushUrl({ url: 'pages/chat/SelectContactPage' });
  }

  static toHomeworkList(): void {
    router.pushUrl({ url: 'pages/homework/HomeworkListPage' });
  }

  static toHomeworkDetail(homeworkId: string): void {
    router.pushUrl({ url: 'pages/homework/HomeworkDetailPage', params: { homeworkId } });
  }

  static toAssignHomework(): void {
    const store = UserStore.getInstance();
    if (!store.isTeacher()) {
      promptAction.openToast({ message: '仅教师可布置作业' });
      return;
    }
    router.pushUrl({ url: 'pages/homework/AssignHomeworkPage' });
  }

  static toSubmitHomework(homeworkId: string): void {
    router.pushUrl({ url: 'pages/homework/SubmitHomeworkPage', params: { homeworkId } });
  }

  static toActivityList(): void {
    router.pushUrl({ url: 'pages/activity/ActivityListPage' });
  }

  static toActivityDetail(activityId: string): void {
    router.pushUrl({ url: 'pages/activity/ActivityDetailPage', params: { activityId } });
  }

  static toAttendanceList(studentId?: string): void {
    router.pushUrl({ url: 'pages/attendance/AttendanceListPage', params: { studentId } });
  }

  static toAttendanceDetail(date: string, studentId: string): void {
    router.pushUrl({ url: 'pages/attendance/AttendanceDetailPage', params: { date, studentId } });
  }

  static toGradeList(studentId?: string): void {
    router.pushUrl({ url: 'pages/grade/GradeListPage', params: { studentId } });
  }

  static toGradeDetail(reportId: string): void {
    router.pushUrl({ url: 'pages/grade/GradeDetailPage', params: { reportId } });
  }

  static toHealthRecordList(studentId?: string): void {
    router.pushUrl({ url: 'pages/health/HealthRecordListPage', params: { studentId } });
  }

  static toHealthDetail(recordId: string): void {
    router.pushUrl({ url: 'pages/health/HealthDetailPage', params: { recordId } });
  }

  static toEvaluationList(studentId?: string): void {
    router.pushUrl({ url: 'pages/evaluation/EvaluationListPage', params: { studentId } });
  }

  static toWriteEvaluation(studentId: string, studentName?: string): void {
    const store = UserStore.getInstance();
    if (!store.isTeacher()) {
      promptAction.openToast({ message: '仅教师可写评价' });
      return;
    }
    router.pushUrl({ url: 'pages/evaluation/WriteEvaluationPage', params: { studentId, studentName } });
  }
}
