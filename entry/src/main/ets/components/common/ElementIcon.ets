import { Constants } from '../../utils/Constants';

@Component
export struct ElementIcon {
  @Prop name: string = 'Grid';
  @Prop size: number = 22;
  @Prop color: string = Constants.COLOR_PRIMARY;

  build() {
    Text(this.glyph())
      .width(this.size)
      .height(this.size)
      .fontSize(Math.max(12, this.size - 4))
      .fontWeight(FontWeight.Medium)
      .fontColor(this.color)
      .textAlign(TextAlign.Center)
      .maxLines(1)
  }

  private glyph(): string {
    if (this.name === 'Home' || this.name === 'House') {
      return '⌂';
    }
    if (this.name === 'Message' || this.name === 'ChatDotRound') {
      return '✉';
    }
    if (this.name === 'User' || this.name === 'UserFilled') {
      return '◉';
    }
    if (this.name === 'Bell' || this.name === 'Notification') {
      return '!';
    }
    if (this.name === 'Edit' || this.name === 'EditPen') {
      return '✎';
    }
    if (this.name === 'Document' || this.name === 'Tickets') {
      return '▤';
    }
    if (this.name === 'Chart' || this.name === 'TrendCharts') {
      return '▥';
    }
    if (this.name === 'Check' || this.name === 'CircleCheck') {
      return '✓';
    }
    if (this.name === 'Health' || this.name === 'FirstAidKit') {
      return '+';
    }
    if (this.name === 'Star' || this.name === 'StarFilled') {
      return '☆';
    }
    if (this.name === 'Calendar') {
      return '□';
    }
    if (this.name === 'School' || this.name === 'OfficeBuilding') {
      return '▦';
    }
    if (this.name === 'Team' || this.name === 'UserGroup') {
      return '◎';
    }
    if (this.name === 'Archive' || this.name === 'Box') {
      return '▣';
    }
    if (this.name === 'AddUser' || this.name === 'UserPlus') {
      return '+';
    }
    if (this.name === 'Search') {
      return '⌕';
    }
    if (this.name === 'Close') {
      return '×';
    }
    if (this.name === 'ChevronRight') {
      return '›';
    }
    if (this.name === 'ChevronDown') {
      return '⌄';
    }
    if (this.name === 'Back') {
      return '‹';
    }
    if (this.name === 'Location') {
      return '⌖';
    }
    if (this.name === 'Image') {
      return '▧';
    }
    return '▦';
  }
}
