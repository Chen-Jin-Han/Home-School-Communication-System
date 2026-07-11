import { Constants } from '../../utils/Constants';

@Component
export struct FormRow {
  @Prop label: string = '';
  @Prop required: boolean = false;
  @Prop errorMsg: string = '';
  @BuilderParam content?: () => void;

  build() {
    Column() {
      Row() {
        if (this.required) {
          Text('*')
            .fontSize(Constants.FONT_MD)
            .fontColor(Constants.COLOR_DANGER)
            .margin({ right: 2 })
        }
        Text(this.label)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .padding({ bottom: Constants.SPACE_SM })

      if (this.content) {
        this.content();
      }

      if (this.errorMsg) {
        Text(this.errorMsg)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_DANGER)
          .margin({ top: Constants.SPACE_XS })
      }
    }
    .width('100%')
    .padding({
      left: Constants.SPACE_LG,
      right: Constants.SPACE_LG,
      top: Constants.SPACE_MD,
      bottom: Constants.SPACE_SM,
    })
  }
}
