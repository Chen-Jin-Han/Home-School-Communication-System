export type NoticeType = 'notification' | 'announcement' | 'news';
export type NoticeScope = 'all' | 'grade' | 'class' | 'teacher' | 'parent';

export interface Attachment {
  id: string;
  name: string;
  url: string;
  size: number;
  mimeType: string;
}

export interface Notice {
  id: string;
  title: string;
  summary: string;
  content: string;
  type: NoticeType;
  publisherId: string;
  publisherName: string;
  publisherAvatar: string;
  scope: NoticeScope;
  scopeTargetId?: string;
  attachments: Attachment[];
  isTop: boolean;
  viewCount: number;
  createdAt: number | string;
  updatedAt: number | string;
}

export interface NoticeQuery {
  type?: NoticeType;
  scope?: NoticeScope;
  keyword?: string;
  page: number;
  pageSize: number;
}
