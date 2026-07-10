import { Conversation, Message, Participant } from '../models/ChatModel';
import { UserRole } from '../models/UserModel';

export class MockChats {
  static conversations: Conversation[] = [
    {
      id: 'conv001',
      type: 'private',
      name: '李老师',
      avatar: '',
      participants: [
        { userId: 'p001', userName: '张伟', avatar: '', role: UserRole.PARENT } as Participant,
        { userId: 't001', userName: '李老师', avatar: '', role: UserRole.TEACHER } as Participant,
      ],
      unreadCount: 2,
      updatedAt: Date.now() - 600000,
    } as Conversation,
    {
      id: 'conv002',
      type: 'group',
      name: '三年级(2)班班级群',
      avatar: '',
      participants: [
        { userId: 't001', userName: '李老师', avatar: '', role: UserRole.TEACHER } as Participant,
        { userId: 'p001', userName: '张伟', avatar: '', role: UserRole.PARENT } as Participant,
        { userId: 's001', userName: '张小伟', avatar: '', role: UserRole.STUDENT } as Participant,
      ],
      unreadCount: 15,
      updatedAt: Date.now() - 1800000,
    } as Conversation,
    {
      id: 'conv003',
      type: 'group',
      name: '三年级教研组',
      avatar: '',
      participants: [
        { userId: 't001', userName: '李老师', avatar: '', role: UserRole.TEACHER } as Participant,
        { userId: 't002', userName: '王老师', avatar: '', role: UserRole.TEACHER } as Participant,
        { userId: 'l001', userName: '王校长', avatar: '', role: UserRole.LEADER } as Participant,
      ],
      unreadCount: 0,
      updatedAt: Date.now() - 7200000,
    } as Conversation,
    {
      id: 'conv004',
      type: 'private',
      name: '王校长',
      avatar: '',
      participants: [
        { userId: 't001', userName: '李老师', avatar: '', role: UserRole.TEACHER } as Participant,
        { userId: 'l001', userName: '王校长', avatar: '', role: UserRole.LEADER } as Participant,
      ],
      unreadCount: 0,
      updatedAt: Date.now() - 86400000,
    } as Conversation,
  ];

  static messages: Record<string, Message[]> = {
    'conv001': [
      {
        id: 'msg001', conversationId: 'conv001', senderId: 't001',
        senderName: '李老师', senderAvatar: '', type: 'text',
        content: '张伟家长您好，张小伟最近上课注意力不够集中，想跟您沟通一下。',
        createdAt: Date.now() - 3000000, status: 'read',
      } as Message,
      {
        id: 'msg002', conversationId: 'conv001', senderId: 'p001',
        senderName: '张伟', senderAvatar: '', type: 'text',
        content: '李老师您好，谢谢您的反馈。我会跟孩子谈谈，最近晚上玩游戏比较多，我注意控制。',
        createdAt: Date.now() - 2400000, status: 'read',
      } as Message,
      {
        id: 'msg003', conversationId: 'conv001', senderId: 't001',
        senderName: '李老师', senderAvatar: '', type: 'text',
        content: '好的，家校配合效果最好。另外这周的语文作业有点难度，需要家长辅导一下。',
        createdAt: Date.now() - 1200000, status: 'read',
      } as Message,
      {
        id: 'msg004', conversationId: 'conv001', senderId: 't001',
        senderName: '李老师', senderAvatar: '', type: 'text',
        content: '主要是阅读理解部分，让孩子多读两遍文章再答题。',
        createdAt: Date.now() - 600000, status: 'read',
      } as Message,
    ] as Message[],
    'conv002': [
      {
        id: 'msg005', conversationId: 'conv002', senderId: 't001',
        senderName: '李老师', senderAvatar: '', type: 'text',
        content: '各位家长和同学们好，这是本周的家庭作业通知，请大家留意完成。',
        createdAt: Date.now() - 1800000, status: 'read',
      } as Message,
      {
        id: 'msg006', conversationId: 'conv002', senderId: 'p001',
        senderName: '张伟', senderAvatar: '', type: 'text',
        content: '收到，谢谢李老师。',
        createdAt: Date.now() - 1600000, status: 'read',
      } as Message,
      {
        id: 'msg007', conversationId: 'conv002', senderId: 't001',
        senderName: '李老师', senderAvatar: '', type: 'text',
        content: '另外提醒一下，明天请带好跳绳，体育课要用。',
        createdAt: Date.now() - 500000, status: 'read',
      } as Message,
    ] as Message[],
    'conv003': [
      {
        id: 'msg008', conversationId: 'conv003', senderId: 'l001',
        senderName: '王校长', senderAvatar: '', type: 'text',
        content: '各位老师好，下周三的教研活动改为周五进行，请大家知悉。',
        createdAt: Date.now() - 7200000, status: 'read',
      } as Message,
    ] as Message[],
    'conv004': [
      {
        id: 'msg009', conversationId: 'conv004', senderId: 'l001',
        senderName: '王校长', senderAvatar: '', type: 'text',
        content: '李老师，您提交的教学计划我已收到，写得很好。',
        createdAt: Date.now() - 86400000, status: 'read',
      } as Message,
    ] as Message[],
  };
}
