import { Constants } from '../../utils/Constants';

@Component
export struct FormTextInput {
  @Link value: string;
  @Prop placeholder: string = '请输入';
  @Prop maxLength: number = 100;
  @Prop inputType: InputType = InputType.Normal;
  onChange?: (value: string) => void;

  build() {
    TextInput({ placeholder: this.placeholder, text: this.value })
      .width('100%')
      .height(44)
      .fontSize(Constants.FONT_MD)
      .fontColor(Constants.COLOR_TEXT_PRIMARY)
      .placeholderColor(Constants.COLOR_TEXT_HINT)
      .maxLength(this.maxLength)
      .type(this.inputType)
      .backgroundColor(Constants.COLOR_BG)
      .borderRadius(Constants.BUTTON_RADIUS)
      .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
      .onChange((value: string) => {
        this.value = value;
        if (this.onChange) {
          this.onChange(value);
        }
      })
  }
}
