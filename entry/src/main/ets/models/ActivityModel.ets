export interface ActivityPhoto {
  id: string;
  url: string;
  thumbnailUrl: string;
  uploadedBy: string;
  uploaderName: string;
  uploaderAvatar: string;
  uploadedAt: number;
  likeCount: number;
  isLiked: boolean;
}

export interface ActivityComment {
  id: string;
  userId: string;
  userName: string;
  avatar: string;
  content: string;
  createdAt: number;
}

export interface Activity {
  id: string;
  title: string;
  description: string;
  coverImage: string;
  organizerId: string;
  organizerName: string;
  location: string;
  startTime: number;
  endTime: number;
  participantCount: number;
  maxParticipants: number;
  photos: ActivityPhoto[];
  status: 'upcoming' | 'ongoing' | 'ended';
  createdAt: number;
}
