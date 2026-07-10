import { BaseService, ApiResponse, PageResult } from './BaseService';
import { Conversation, Message } from '../models/ChatModel';
import { MockChats } from '../mock/MockChats';
import { Constants } from '../utils/Constants';

export class ChatService extends BaseService {
  static async getConversations(): Promise<ApiResponse<Conversation[]>> {
    await BaseService.simulateDelay();
    const sorted = [...MockChats.conversations].sort(
      (a, b) => b.updatedAt - a.updatedAt
    );
    return BaseService.success(sorted);
  }

  static async getMessages(
    conversationId: string,
    page: number
  ): Promise<ApiResponse<PageResult<Message>>> {
    await BaseService.simulateDelay();
    const messagesMap = MockChats.messages as Record<string, Message[]>;
    const msgs = messagesMap[conversationId] || [];
    const sorted = [...msgs].sort((a, b) => a.createdAt - b.createdAt);
    return BaseService.success(BaseService.paginate(sorted, page, Constants.PAGE_SIZE));
  }

  static async sendMessage(message: Message): Promise<ApiResponse<Message>> {
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

  static async getConversation(conversationId: string): Promise<ApiResponse<Conversation | undefined>> {
    await BaseService.simulateDelay();
    return BaseService.success(MockChats.conversations.find(c => c.id === conversationId));
  }
}
