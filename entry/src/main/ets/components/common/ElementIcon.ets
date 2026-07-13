import { Constants } from '../../utils/Constants';

@Component
export struct ElementIcon {
  @Prop name: string = 'Grid';
  @Prop iconSize: number = 22;
  @Prop color: string = Constants.COLOR_PRIMARY;

  build() {
    Text(this.glyph())
      .width(this.iconSize)
      .height(this.iconSize)
      .fontSize(Math.max(12, this.iconSize - 4))
      .fontWeight(FontWeight.Medium)
      .fontColor(this.color)
      .textAlign(TextAlign.Center)
      .maxLines(1)
  }

  private glyph(): string {
    if (this.name === 'Home' || this.name === 'House') {
      return 'H';
    }
    if (this.name === 'Message' || this.name === 'ChatDotRound') {
      return 'M';
    }
    if (this.name === 'User' || this.name === 'UserFilled') {
      return 'U';
    }
    if (this.name === 'Bell' || this.name === 'Notification') {
      return 'N';
    }
    if (this.name === 'Edit' || this.name === 'EditPen') {
      return 'E';
    }
    if (this.name === 'Document' || this.name === 'Tickets') {
      return 'D';
    }
    if (this.name === 'Chart' || this.name === 'TrendCharts') {
      return 'C';
    }
    if (this.name === 'Check' || this.name === 'CircleCheck') {
      return 'V';
    }
    if (this.name === 'Health' || this.name === 'FirstAidKit') {
      return '+';
    }
    if (this.name === 'Star' || this.name === 'StarFilled') {
      return '*';
    }
    if (this.name === 'Calendar') {
      return 'T';
    }
    if (this.name === 'School' || this.name === 'OfficeBuilding') {
      return 'S';
    }
    if (this.name === 'Team' || this.name === 'UserGroup') {
      return 'G';
    }
    if (this.name === 'Archive' || this.name === 'Box') {
      return 'B';
    }
    if (this.name === 'AddUser' || this.name === 'UserPlus') {
      return '+';
    }
    if (this.name === 'Search') {
      return '?';
    }
    if (this.name === 'Close') {
      return 'x';
    }
    if (this.name === 'ChevronRight') {
      return '>';
    }
    if (this.name === 'ChevronDown') {
      return 'v';
    }
    if (this.name === 'Back') {
      return '<';
    }
    if (this.name === 'Location') {
      return 'P';
    }
    if (this.name === 'Image') {
      return 'I';
    }
    return 'A';
  }
}
