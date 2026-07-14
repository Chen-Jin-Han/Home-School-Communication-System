import { UserRole } from './UserModel';

export type ConversationType = 'private' | 'group';
export type MessageType = 'text' | 'image' | 'voice';
export type MessageStatus = 'sending' | 'sent' | 'read' | 'recalled';

export interface Participant {
  userId: string;
  userName: string;
  avatar: string;
  role: UserRole;
}

export interface Message {
  id: string;
  conversationId: string;
  senderId: string;
  senderName: string;
  senderAvatar: string;
  type: MessageType;
  content: string;
  duration?: number;
  createdAt: number | string;
  status: MessageStatus;
}

export interface Conversation {
  id: string;
  type: ConversationType;
  name: string;
  avatar: string;
  participants: Participant[];
  lastMessage?: Message;
  unreadCount: number;
  updatedAt: number | string;
}
