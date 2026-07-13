import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';
import { ElementIcon } from '../common/ElementIcon';

@Component
export struct FormDatePicker {
  @Link timestamp: number;
  @Prop placeholder: string = '请选择日期';
  onChange?: (value: number) => void;
  
  // 用于记录选中的日期
  private selectedDate: Date = new Date();

  build() {
    Row() {
      Text(this.timestamp > 0 ? DateUtil.formatDate(this.timestamp) : this.placeholder)
        .fontSize(Constants.FONT_MD)
        .fontColor(this.timestamp > 0 ? Constants.COLOR_TEXT_PRIMARY : Constants.COLOR_TEXT_HINT)
        .layoutWeight(1)

      ElementIcon({ name: 'Calendar', iconSize: 18, color: Constants.COLOR_TEXT_HINT })
    }
    .width('100%')
    .height(44)
    .backgroundColor(Constants.COLOR_SURFACE)
    .borderRadius(Constants.BUTTON_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
    .onClick(() => {
      // 如果已有时间戳，则使用该日期作为默认选中日期
      if (this.timestamp > 0) {
        this.selectedDate = new Date(this.timestamp);
      } else {
        this.selectedDate = new Date();
      }
      
      // 弹出日期选择器弹窗
      DatePickerDialog.show({
        start: this.selectedDate,
        end: new Date('2100-12-31'),
        selected: this.selectedDate,
        lunar: false,
        canLoop: false,
        onAccept: (value: DatePickerResult) => {
          // 用户点击确定按钮，更新时间戳
          const selectedDate = new Date(value.year, value.month, value.day);
          this.timestamp = selectedDate.getTime();
          
          // 更新 selectedDate 以便下次打开时默认选中上次选择的日期
          this.selectedDate = selectedDate;
          
          // 触发回调
          if (this.onChange) {
            this.onChange(this.timestamp);
          }
        },
        onCancel: () => {
          // 用户点击取消按钮，不做任何操作
        }
      });
    })
  }
}
