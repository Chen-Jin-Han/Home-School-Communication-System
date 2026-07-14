import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';
import { ElementIcon } from '../common/ElementIcon';

@Component
export struct FormDatePicker {
  @Link timestamp: number;
  @Prop placeholder: string = '请选择日期';
  @Prop allowPast: boolean = false;
  @Prop allowFuture: boolean = true;
  @Prop startTimestamp: number = 0;
  @Prop endTimestamp: number = 0;
  onChange?: (value: number) => void;

  private selectedDate: Date = new Date();

  private pickerStart(): Date {
    if (this.startTimestamp > 0) {
      return new Date(this.startTimestamp);
    }
    return this.allowPast ? new Date('1970-01-01') : new Date();
  }

  private pickerEnd(): Date {
    if (this.endTimestamp > 0) {
      return new Date(this.endTimestamp);
    }
    return this.allowFuture ? new Date('2100-12-31') : new Date();
  }

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
      this.selectedDate = this.timestamp > 0 ? new Date(this.timestamp) : new Date();
      DatePickerDialog.show({
        start: this.pickerStart(),
        end: this.pickerEnd(),
        selected: this.selectedDate,
        lunar: false,
        canLoop: false,
        onAccept: (value: DatePickerResult) => {
          const selectedDate = new Date(value.year, value.month, value.day);
          this.timestamp = selectedDate.getTime();
          this.selectedDate = selectedDate;
          if (this.onChange) {
            this.onChange(this.timestamp);
          }
        },
      });
    })
  }
}
