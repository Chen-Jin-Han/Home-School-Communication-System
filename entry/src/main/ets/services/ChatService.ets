import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Conversation, Message } from '../models/ChatModel';
import { MockChats } from '../mock/MockChats';
import { Constants } from '../utils/Constants';
import { USE_MOCK } from './MockConfig';
import { HttpUtil } from './HttpUtil';
import { UserStore } from '../store/UserStore';

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
      const arr = messagesMap[message.conversationId];
      if (arr) {
        arr.push(message);
      }
      // Update conversation's lastMessage
      const conv = MockChats.conversations.find(c => c.id === message.conversationId);
      if (conv) {
        conv.lastMessage = message;
        conv.updatedAt = Date.now();
      }
      return BaseService.success(message);
    }
    return HttpUtil.post<Message>(
      `/api/conversations/${message.conversationId}/messages`,
      message,
      UserStore.getInstance().authToken
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
}
