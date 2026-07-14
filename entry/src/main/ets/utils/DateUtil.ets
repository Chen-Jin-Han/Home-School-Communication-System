const BEIJING_OFFSET_MS: number = 8 * 60 * 60 * 1000;

export class DateUtil {
  static toMillis(value: number | string | null | undefined): number {
    if (value === null || value === undefined || value === '') {
      return 0;
    }
    if (typeof value === 'number') {
      return value > 10000000000 ? value : value * 1000;
    }
    const text = value.trim();
    if (!text) {
      return 0;
    }
    if (/^\d+$/.test(text)) {
      const num = Number(text);
      return num > 10000000000 ? num : num * 1000;
    }
    const hasTimezone = text.endsWith('Z') || /[+-]\d{2}:?\d{2}$/.test(text);
    const normalized = text.indexOf('T') >= 0 && !hasTimezone ? `${text}Z` : text;
    const parsed = new Date(normalized).getTime();
    return Number.isNaN(parsed) ? 0 : parsed;
  }

  private static beijingDate(timestamp: number | string | null | undefined): Date {
    const millis = DateUtil.toMillis(timestamp);
    return new Date((millis || Date.now()) + BEIJING_OFFSET_MS);
  }

  static formatDate(timestamp: number | string | null | undefined): string {
    if (!DateUtil.toMillis(timestamp)) {
      return '';
    }
    const d = DateUtil.beijingDate(timestamp);
    const y = d.getUTCFullYear();
    const m = String(d.getUTCMonth() + 1).padStart(2, '0');
    const day = String(d.getUTCDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
  }

  static formatTime(timestamp: number | string | null | undefined): string {
    if (!DateUtil.toMillis(timestamp)) {
      return '';
    }
    const d = DateUtil.beijingDate(timestamp);
    const h = String(d.getUTCHours()).padStart(2, '0');
    const min = String(d.getUTCMinutes()).padStart(2, '0');
    return `${h}:${min}`;
  }

  static formatDateTime(timestamp: number | string | null | undefined): string {
    const date = DateUtil.formatDate(timestamp);
    const time = DateUtil.formatTime(timestamp);
    return date && time ? `${date} ${time}` : '';
  }

  static timeAgo(timestamp: number | string | null | undefined): string {
    const millis = DateUtil.toMillis(timestamp);
    if (!millis) {
      return '';
    }
    const diff = Math.max(Date.now() - millis, 0);
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
    const y = parts[0] || '';
    const m = parts[1] || '';
    return `${y}年${parseInt(m)}月`;
  }
}
