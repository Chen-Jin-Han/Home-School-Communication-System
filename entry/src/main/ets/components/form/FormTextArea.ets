import { Constants } from '../../utils/Constants';

@Component
export struct FormTextArea {
  @Link value: string;
  @Prop placeholder: string = '请输入内容';
  @Prop maxLength: number = 500;
  onChange?: (value: string) => void;

  build() {
    Column() {
      TextArea({ placeholder: this.placeholder, text: this.value })
        .width('100%')
        .height(120)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .placeholderColor(Constants.COLOR_TEXT_HINT)
        .maxLength(this.maxLength)
        .backgroundColor(Constants.COLOR_BG)
        .borderRadius(Constants.BUTTON_RADIUS)
        .padding(Constants.SPACE_MD)
        .onChange((value: string) => {
          this.value = value;
          if (this.onChange) {
            this.onChange(value);
          }
        })
      Row() {
        Blank()
        Text(`${this.value.length}/${this.maxLength}`)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
      }
      .width('100%')
      .margin({ top: Constants.SPACE_XS })
    }
    .width('100%')
  }
}
