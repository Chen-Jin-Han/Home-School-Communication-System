import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';

@Component
export struct FormDatePicker {
  @Link timestamp: number;
  @Prop placeholder: string = '请选择日期';
  onChange?: (value: number) => void;

  build() {
    Row() {
      Text(this.timestamp > 0 ? DateUtil.formatDate(this.timestamp) : this.placeholder)
        .fontSize(Constants.FONT_MD)
        .fontColor(this.timestamp > 0 ? Constants.COLOR_TEXT_PRIMARY : Constants.COLOR_TEXT_HINT)
        .layoutWeight(1)

      Image($r('sys.symbol.calendar'))
        .width(18)
        .height(18)
        .fillColor(Constants.COLOR_TEXT_HINT)
    }
    .width('100%')
    .height(44)
    .backgroundColor(Constants.COLOR_SURFACE)
    .borderRadius(Constants.BUTTON_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
    .onClick(() => {
      this.timestamp = Date.now();
      if (this.onChange) {
        this.onChange(this.timestamp);
      }
    })
  }
}
