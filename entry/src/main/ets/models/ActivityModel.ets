export interface ActivityPhoto {
  id: string;
  url: string;
  thumbnailUrl: string;
  uploadedBy: string;
  uploaderName: string;
  uploaderAvatar: string;
  uploadedAt: number | string;
  likeCount: number;
  isLiked: boolean;
}

export interface ActivityComment {
  id: string;
  activityId: string;
  userId: string;
  userName: string;
  userAvatar: string;
  role: string;
  content: string;
  createdAt: number | string;
}

export interface ActivityCommentPayload {
  content: string;
}

export interface Activity {
  id: string;
  title: string;
  description: string;
  coverImage: string;
  organizerId: string;
  organizerName: string;
  location: string;
  startTime: number | string;
  endTime: number | string;
  participantCount: number;
  maxParticipants: number;
  photos: ActivityPhoto[];
  status: 'upcoming' | 'ongoing' | 'ended';
  createdAt: number | string;
}
