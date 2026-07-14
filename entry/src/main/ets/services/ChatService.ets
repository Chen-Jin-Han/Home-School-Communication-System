import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Conversation, Message, Participant } from '../models/ChatModel';
import { MockChats } from '../mock/MockChats';
import { Constants } from '../utils/Constants';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';
import { UserRole } from '../models/UserModel';

interface CreatePrivateConversationRequest {
  targetUserId: string;
}

interface SendMessageRequest {
  content: string;
}

interface UnreadCountResult {
  count: number;
}

export class ChatService extends BaseService {
  static async getConversations(): Promise<ApiResponse<Conversation[]>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const sorted = [...MockChats.conversations].sort(
        (a, b) => b.updatedAt - a.updatedAt
      );
      return BaseService.success(sorted);
    }
    return HttpUtil.get<Conversation[]>('/api/conversations', UserStore.getInstance().authToken);
  }

  static async getMessages(
    conversationId: string,
    page: number
  ): Promise<ApiResponse<PageResult<Message>>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      // Reset unread count for this conversation (mark as read)
      const conv = MockChats.conversations.find(c => c.id === conversationId);
      if (conv) {
        conv.unreadCount = 0;
      }
      const messagesMap = MockChats.messages as Record<string, Message[]>;
      const msgs = messagesMap[conversationId] || [];
      const sorted = [...msgs].sort((a, b) => a.createdAt - b.createdAt);
      return BaseService.success(BaseService.paginate(sorted, page, Constants.PAGE_SIZE));
    }
    return HttpUtil.get<PageResult<Message>>(
      `/api/conversations/${conversationId}/messages?page=${page}&pageSize=${Constants.PAGE_SIZE}`,
      UserStore.getInstance().authToken
    );
  }

  static async sendMessage(message: Message): Promise<ApiResponse<Message>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const messagesMap = MockChats.messages as Record<string, Message[]>;
      let arr = messagesMap[message.conversationId];
      if (!arr) {
        arr = [];
        messagesMap[message.conversationId] = arr;
      }
      arr.push(message);
      // Update conversation's lastMessage
      const conv = MockChats.conversations.find(c => c.id === message.conversationId);
      if (conv) {
        conv.lastMessage = message;
        conv.updatedAt = Date.now();
      }
      return BaseService.success(message);
    }
    const request: SendMessageRequest = {
      content: message.content,
    };
    return HttpUtil.post<Message>(
      `/api/conversations/${message.conversationId}/messages`,
      request
    );
  }

  static async getConversation(conversationId: string): Promise<ApiResponse<Conversation | undefined>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      return BaseService.success(MockChats.conversations.find(c => c.id === conversationId));
    }
    return HttpUtil.get<Conversation | undefined>(
      `/api/conversations/${conversationId}`,
      UserStore.getInstance().authToken
    );
  }

  static async createPrivateConversation(targetUserId: string): Promise<ApiResponse<Conversation>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const existing = MockChats.conversations.find(c =>
        c.type === 'private' && c.participants.some(p => p.userId === targetUserId)
      );
      if (existing) {
        return BaseService.success(existing);
      }
      const currentUser = UserStore.getInstance().currentUser;
      const currentParticipant: Participant = {
        userId: currentUser ? currentUser.id : '',
        userName: currentUser ? currentUser.name : '',
        avatar: currentUser ? currentUser.avatar : '',
        role: currentUser ? currentUser.role : UserRole.PARENT,
      };
      const targetParticipant: Participant = {
        userId: targetUserId,
        userName: targetUserId,
        avatar: '',
        role: UserRole.PARENT,
      };
      const conv: Conversation = {
        id: `conv_${Date.now()}`,
        type: 'private',
        name: '新会话',
        avatar: '',
        participants: [currentParticipant, targetParticipant],
        unreadCount: 0,
        updatedAt: Date.now(),
      };
      MockChats.conversations.unshift(conv);
      return BaseService.success(conv);
    }
    const request: CreatePrivateConversationRequest = {
      targetUserId: targetUserId,
    };
    return HttpUtil.post<Conversation>(
      '/api/conversations',
      request,
      UserStore.getInstance().authToken
    );
  }

  static async getUnreadCount(): Promise<ApiResponse<UnreadCountResult>> {
    if (USE_MOCK) {
      await BaseService.simulateDelay();
      const total = MockChats.conversations.reduce(
        (sum, c) => sum + (c.unreadCount || 0), 0
      );
      const result: UnreadCountResult = { count: total };
      return BaseService.success(result);
    }
    return HttpUtil.get<UnreadCountResult>(
      '/api/conversations/unread-count',
      UserStore.getInstance().authToken
    );
  }
}
