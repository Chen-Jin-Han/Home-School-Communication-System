import { Constants } from '../../utils/Constants';

@Component
export struct ElementIcon {
  @Prop name: string = 'Grid';
  @Prop iconSize: number = 22;
  @Prop color: string = Constants.COLOR_PRIMARY;

  build() {
    Shape() {
      Path()
        .commands(this.scaledPath())
        .fillOpacity(0)
        .stroke(this.color)
        .strokeWidth(this.strokeW())
        .strokeLineCap(LineCapStyle.Round)
        .strokeLineJoin(LineJoinStyle.Round)
    }
    .viewPort({ x: 0, y: 0, width: this.iconSize, height: this.iconSize })
    .width(this.iconSize)
    .height(this.iconSize)
  }

  private strokeW(): number {
    return Math.max(1.6, this.iconSize / 11);
  }

  private scaledPath(): string {
    const scale: number = this.iconSize / 24;
    const base: string = this.pathData();
    const tokens: string[] = base.split(' ');
    const out: string[] = [];
    for (let i = 0; i < tokens.length; i++) {
      const t: string = tokens[i];
      if (t.length === 0) {
        continue;
      }
      if (this.isNumber(t)) {
        const v: number = parseFloat(t) * scale;
        out.push((Math.round(v * 10) / 10).toString());
      } else if (t.length > 1 && this.isNumber(t.substring(1))) {
        const v: number = parseFloat(t.substring(1)) * scale;
        out.push(t.charAt(0) + (Math.round(v * 10) / 10).toString());
      } else {
        out.push(t);
      }
    }
    return out.join(' ');
  }

  private isNumber(s: string): boolean {
    if (s.length === 0) {
      return false;
    }
    const code: number = s.charCodeAt(0);
    if (s.length === 1) {
      return code >= 0x30 && code <= 0x39;
    }
    let start: number = 0;
    if (s.charAt(0) === '-' || s.charAt(0) === '+') {
      start = 1;
    }
    if (start === s.length) {
      return false;
    }
    let dotSeen: boolean = false;
    for (let i = start; i < s.length; i++) {
      const c: number = s.charCodeAt(i);
      if (c === 0x2E) {
        if (dotSeen) {
          return false;
        }
        dotSeen = true;
      } else if (c < 0x30 || c > 0x39) {
        return false;
      }
    }
    return true;
  }

  private pathData(): string {
    const n = this.name;
    if (n === 'Home' || n === 'House') {
      return 'M3 10.5 L12 3.6 L21 10.5 M5 9.5 V20 H19 V9.5 M10.5 20 V14.5 H13.5 V20';
    }
    if (n === 'Message' || n === 'ChatDotRound') {
      return 'M4 5 H20 V15 H9 L5 19 V15 H4 Z';
    }
    if (n === 'User' || n === 'UserFilled') {
      return 'M8 7 A4 4 0 1 0 16 7 A4 4 0 1 0 8 7 Z M4 20 A8 8 0 0 1 20 20';
    }
    if (n === 'Bell' || n === 'Notification') {
      return 'M7 16 H17 L16 15 V11 A5 5 0 0 0 7 11 V15 Z M10 16 A2 2 0 0 0 14 16 M9.5 19 H14.5';
    }
    if (n === 'Edit' || n === 'EditPen') {
      return 'M3 21 L3 17 L17 3 L21 7 L7 21 Z M13 7 L17 11';
    }
    if (n === 'Document' || n === 'Tickets') {
      return 'M6 3 H14 L18 7 V21 H6 Z M14 3 V7 H18 M9 12 H15 M9 16 H15 M9 19 H13';
    }
    if (n === 'Chart' || n === 'TrendCharts') {
      return 'M4 20 H20 M7 20 V12 M12 20 V7 M17 20 V14';
    }
    if (n === 'Check' || n === 'CircleCheck') {
      return 'M5 12.5 L10 17 L19 6';
    }
    if (n === 'Health' || n === 'FirstAidKit') {
      return 'M5 4 H19 V20 H5 Z M12 8 V16 M8 12 H16';
    }
    if (n === 'Star' || n === 'StarFilled') {
      return 'M12 3.5 L14.6 9.5 L21 10 L16 14.5 L17.5 21 L12 17.5 L6.5 21 L8 14.5 L3 10 L9.4 9.5 Z';
    }
    if (n === 'Calendar') {
      return 'M4 6 H20 V20 H4 Z M4 10 H20 M8 4 V7 M16 4 V7';
    }
    if (n === 'School' || n === 'OfficeBuilding') {
      return 'M4 20 V7 L12 3.5 L20 7 V20 Z M3 20 H21 M10 20 V14 H14 V20';
    }
    if (n === 'Team' || n === 'UserGroup') {
      return 'M8 7 A4 4 0 1 0 16 7 A4 4 0 1 0 8 7 Z M4 20 A8 8 0 0 1 20 20 M14 8 A3 3 0 1 0 20 8 A3 3 0 1 0 14 8 Z M14 20 A6 6 0 0 1 20 14';
    }
    if (n === 'Archive' || n === 'Box') {
      return 'M4 6 H20 V9 H4 Z M5.5 9 V20 H18.5 V9 M10 13 H14';
    }
    if (n === 'AddUser' || n === 'UserPlus') {
      return 'M8 7 A4 4 0 1 0 16 7 A4 4 0 1 0 8 7 Z M4 20 A8 8 0 0 1 16 20 M19 8 V14 M16 11 H22';
    }
    if (n === 'Search') {
      return 'M4 10.5 A6.5 6.5 0 1 0 17 10.5 A6.5 6.5 0 1 0 4 10.5 Z M15 15 L20 20';
    }
    if (n === 'Close') {
      return 'M6 6 L18 18 M18 6 L6 18';
    }
    if (n === 'ChevronRight') {
      return 'M9 6 L15 12 L9 18';
    }
    if (n === 'ChevronDown') {
      return 'M6 9 L12 15 L18 9';
    }
    if (n === 'Back') {
      return 'M15 6 L9 12 L15 18';
    }
    if (n === 'Location') {
      return 'M12 2 C7.6 2 4 5.6 4 10 C4 15.5 12 22 12 22 C12 22 20 15.5 20 10 C20 5.6 16.4 2 12 2 Z M10 10 A2 2 0 1 0 14 10 A2 2 0 1 0 10 10 Z';
    }
    if (n === 'Image') {
      return 'M4 5 H20 V19 H4 Z M4 15 L9 10 L14 15 L17 12 L20 15 M8 8 A1.5 1.5 0 1 0 8 11 A1.5 1.5 0 1 0 8 8 Z';
    }
    return 'M4 4 H10 V10 H4 Z M14 4 H20 V10 H14 Z M4 14 H10 V20 H4 Z M14 14 H20 V20 H14 Z';
  }
}
