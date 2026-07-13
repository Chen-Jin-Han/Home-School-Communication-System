import { StorageUtil } from '../utils/StorageUtil';

interface AppStoreBlob {
  isDarkMode: boolean;
  fontSizeScale: number;
  notificationEnabled: boolean;
  lastSyncTime: number;
  unreadNoticeCount: number;
  unreadHomeworkCount: number;
}

const APP_STORE_KEY = 'app_store';

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

  async init(): Promise<void> {
    const blob = await StorageUtil.getJSON<AppStoreBlob>(APP_STORE_KEY);
    if (blob) {
      this.isDarkMode = blob.isDarkMode;
      this.fontSizeScale = blob.fontSizeScale;
      this.notificationEnabled = blob.notificationEnabled;
      this.lastSyncTime = blob.lastSyncTime;
      this.unreadNoticeCount = blob.unreadNoticeCount;
      this.unreadHomeworkCount = blob.unreadHomeworkCount;
    }
  }

  async setIsDarkMode(value: boolean): Promise<void> {
    this.isDarkMode = value;
    await this.persist();
  }

  async setFontSizeScale(value: number): Promise<void> {
    this.fontSizeScale = value;
    await this.persist();
  }

  async setNotificationEnabled(value: boolean): Promise<void> {
    this.notificationEnabled = value;
    await this.persist();
  }

  async setLastSyncTime(value: number): Promise<void> {
    this.lastSyncTime = value;
    await this.persist();
  }

  async setUnreadNoticeCount(value: number): Promise<void> {
    this.unreadNoticeCount = value;
    await this.persist();
  }

  async setUnreadHomeworkCount(value: number): Promise<void> {
    this.unreadHomeworkCount = value;
    await this.persist();
  }

  private async persist(): Promise<void> {
    const blob: AppStoreBlob = {
      isDarkMode: this.isDarkMode,
      fontSizeScale: this.fontSizeScale,
      notificationEnabled: this.notificationEnabled,
      lastSyncTime: this.lastSyncTime,
      unreadNoticeCount: this.unreadNoticeCount,
      unreadHomeworkCount: this.unreadHomeworkCount,
    };
    await StorageUtil.putJSON(APP_STORE_KEY, blob);
  }
}
