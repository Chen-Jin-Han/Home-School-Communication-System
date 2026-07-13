export class DateUtil {
  static toMillis(value: number | string): number {
    if (typeof value === 'number') {
      return value;
    }
    const parsed = new Date(value).getTime();
    return Number.isNaN(parsed) ? Date.now() : parsed;
  }

  static formatDate(timestamp: number | string): string {
    const d = new Date(DateUtil.toMillis(timestamp));
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
  }

  static formatTime(timestamp: number | string): string {
    const d = new Date(DateUtil.toMillis(timestamp));
    const h = String(d.getHours()).padStart(2, '0');
    const min = String(d.getMinutes()).padStart(2, '0');
    return `${h}:${min}`;
  }

  static formatDateTime(timestamp: number | string): string {
    return `${DateUtil.formatDate(timestamp)} ${DateUtil.formatTime(timestamp)}`;
  }

  static timeAgo(timestamp: number | string): string {
    const now = Date.now();
    const diff = Math.max(now - DateUtil.toMillis(timestamp), 0);
    const sec = Math.floor(diff / 1000);
    if (sec < 60) {
      return '刚刚';
    }
    const min = Math.floor(sec / 60);
    if (min < 60) {
      return `${min}分钟前`;
    }
    const hour = Math.floor(min / 60);
    if (hour < 24) {
      return `${hour}小时前`;
    }
    const day = Math.floor(hour / 24);
    if (day < 7) {
      return `${day}天前`;
    }
    return DateUtil.formatDate(timestamp);
  }

  static getToday(): string {
    return DateUtil.formatDate(Date.now());
  }

  static getMonthLabel(month: string): string {
    const parts = month.split('-');
    const y = parts[0];
    const m = parts[1];
    return `${y}年${parseInt(m)}月`;
  }
}
