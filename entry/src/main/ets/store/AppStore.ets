@Observed
export class AppStore {
  private static _instance: AppStore;

  static getInstance(): AppStore {
    if (!AppStore._instance) {
      AppStore._instance = new AppStore();
    }
    return AppStore._instance;
  }

  isDarkMode: boolean = false;
  fontSizeScale: number = 1.0;
  notificationEnabled: boolean = true;
  lastSyncTime: number = 0;
  unreadNoticeCount: number = 0;
  unreadHomeworkCount: number = 0;
}
