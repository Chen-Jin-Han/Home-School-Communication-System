import { Constants } from '../../utils/Constants';

@Component
export struct ElementIcon {
  @Prop name: string = 'Grid';
  @Prop iconSize: number = 22;
  @Prop color: string = Constants.COLOR_PRIMARY;

  build() {
    SymbolGlyph(this.resolveSymbol())
      .fontSize(this.iconSize)
      .fontColor([this.color])
      .renderingStrategy(SymbolRenderingStrategy.SINGLE)
  }

  private resolveSymbol(): Resource {
    const n = this.name;
    if (n === 'Home' || n === 'House') {
      return $r('sys.symbol.house_fill');
    }
    if (n === 'Message' || n === 'ChatDotRound') {
      return $r('sys.symbol.message_fill');
    }
    if (n === 'User' || n === 'UserFilled') {
      return $r('sys.symbol.person_fill');
    }
    if (n === 'Bell' || n === 'Notification') {
      return $r('sys.symbol.bell_fill');
    }
    if (n === 'Edit' || n === 'EditPen') {
      return $r('sys.symbol.square_and_pencil');
    }
    if (n === 'Document' || n === 'Tickets') {
      return $r('sys.symbol.doc_plaintext_fill_1');
    }
    if (n === 'Chart' || n === 'TrendCharts') {
      return $r('sys.symbol.histogram');
    }
    if (n === 'Check' || n === 'CircleCheck') {
      return $r('sys.symbol.checkmark_circle_fill');
    }
    if (n === 'Health' || n === 'FirstAidKit') {
      return $r('sys.symbol.heart_fill');
    }
    if (n === 'Star' || n === 'StarFilled') {
      return $r('sys.symbol.star_fill');
    }
    if (n === 'Calendar') {
      return $r('sys.symbol.calendar');
    }
    if (n === 'School' || n === 'OfficeBuilding') {
      return $r('sys.symbol.building_fill');
    }
    if (n === 'Team' || n === 'UserGroup') {
      return $r('sys.symbol.person_2_fill');
    }
    if (n === 'Archive' || n === 'Box' || n === 'Empty') {
      return $r('sys.symbol.archivebox_fill');
    }
    if (n === 'AddUser' || n === 'UserPlus') {
      return $r('sys.symbol.person_badge_plus');
    }
    if (n === 'Search') {
      return $r('sys.symbol.magnifyingglass');
    }
    if (n === 'Close' || n === 'Error') {
      return $r('sys.symbol.xmark');
    }
    if (n === 'ChevronRight') {
      return $r('sys.symbol.chevron_right');
    }
    if (n === 'ChevronDown') {
      return $r('sys.symbol.chevron_down');
    }
    if (n === 'Back') {
      return $r('sys.symbol.chevron_left');
    }
    if (n === 'Location') {
      return $r('sys.symbol.pin_fill');
    }
    if (n === 'Image') {
      return $r('sys.symbol.ohos_photo');
    }
    return $r('sys.symbol.square_grid_2x2');
  }
}
