import { Constants } from '../../utils/Constants';

export interface SelectOption {
  label: string;
  value: string;
}

@Component
export struct FormSelector {
  @Link selectedValue: string;
  @Prop placeholder: string = '请选择';
  options: SelectOption[] = [];
  onChange?: (value: string) => void;

  build() {
    Row() {
      Text(this.getSelectedLabel() || this.placeholder)
        .fontSize(Constants.FONT_MD)
        .fontColor(this.selectedValue ? Constants.COLOR_TEXT_PRIMARY : Constants.COLOR_TEXT_HINT)
        .layoutWeight(1)
      Image($r('sys.symbol.chevron_down'))
        .width(16)
        .height(16)
        .fillColor(Constants.COLOR_TEXT_HINT)
    }
    .width('100%')
    .height(44)
    .backgroundColor(Constants.COLOR_BG)
    .borderRadius(Constants.BUTTON_RADIUS)
    .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
    .onClick(() => {
      // In a real implementation, use TextPickerDialog
    })
  }

  getSelectedLabel(): string {
    const opt = this.options.find(o => o.value === this.selectedValue);
    return opt ? opt.label : '';
  }
}
