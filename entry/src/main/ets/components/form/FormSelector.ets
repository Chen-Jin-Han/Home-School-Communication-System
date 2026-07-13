import { Constants } from '../../utils/Constants';
import { ElementIcon } from '../common/ElementIcon';

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

      ElementIcon({ name: 'ChevronDown', size: 16, color: Constants.COLOR_TEXT_HINT })
    }
    .width('100%')
    .height(46)
    .backgroundColor(Constants.COLOR_SURFACE)
    .borderRadius(Constants.BUTTON_RADIUS)
    .border({ width: 0.5, color: Constants.COLOR_BORDER })
    .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
    .onClick(() => {
      if (this.options.length > 0) {
        const index = this.options.findIndex((item: SelectOption) => item.value === this.selectedValue);
        const next = this.options[(index + 1) % this.options.length].value;
        this.selectedValue = next;
        if (this.onChange) {
          this.onChange(next);
        }
      }
    })
  }

  getSelectedLabel(): string {
    const opt = this.options.find((item: SelectOption) => item.value === this.selectedValue);
    return opt ? opt.label : '';
  }
}
