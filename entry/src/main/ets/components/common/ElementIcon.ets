import { Constants } from '../../utils/Constants';

@Component
export struct ElementIcon {
  @Prop name: string = 'Grid';
  @Prop size: number = 22;
  @Prop color: string = Constants.COLOR_PRIMARY;

  build() {
    if (this.name === 'Home') {
      Image($r('sys.symbol.house'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Message') {
      Image($r('sys.symbol.ellipsis_message'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'User') {
      Image($r('sys.symbol.person_crop_circle'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Bell') {
      Image($r('sys.symbol.bell'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Edit') {
      Image($r('sys.symbol.square_and_pencil'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Document') {
      Image($r('sys.symbol.doc_text'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Chart') {
      Image($r('sys.symbol.chart_bar'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Check') {
      Image($r('sys.symbol.checkmark_circle'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Health') {
      Image($r('sys.symbol.heart'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Star') {
      Image($r('sys.symbol.star'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Calendar') {
      Image($r('sys.symbol.calendar'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'School') {
      Image($r('sys.symbol.building_2'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Team') {
      Image($r('sys.symbol.person_2'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Grid') {
      Image($r('sys.symbol.square_grid_2x2'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'Archive') {
      Image($r('sys.symbol.tray_full'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else if (this.name === 'AddUser') {
      Image($r('sys.symbol.person_badge_plus'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    } else {
      Image($r('sys.symbol.square_grid_2x2'))
        .width(this.size)
        .height(this.size)
        .fillColor(this.color)
    }
  }
}
