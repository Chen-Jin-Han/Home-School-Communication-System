import { Constants } from '../../utils/Constants';

@Component
export struct ErrorView {
  @Prop message: string = '加载失败，请重试';
  onRetry?: () => void;

  build() {
    Column() {
      Text('⚠️')
        .fontSize(48)
        .margin({ bottom: Constants.SPACE_LG })
      Text(this.message)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .textAlign(TextAlign.Center)
        .padding({ left: Constants.SPACE_XL, right: Constants.SPACE_XL })
      Blank().height(Constants.SPACE_LG)
      Button('重试')
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_PRIMARY)
        .fontColor(Constants.COLOR_WHITE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .onClick(() => {
          if (this.onRetry) {
            this.onRetry();
          }
        })
    }
    .width('100%')
    .height('60%')
    .justifyContent(FlexAlign.Center)
  }
}
