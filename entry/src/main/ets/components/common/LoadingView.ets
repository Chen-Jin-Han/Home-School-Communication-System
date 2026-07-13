import { Constants } from '../../utils/Constants';

@Component
export struct LoadingView {
  @Prop message: string = '加载中...';

  build() {
    Column() {
      LoadingProgress()
        .width(36)
        .height(36)
        .color(Constants.COLOR_PRIMARY)
      Text(this.message)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .margin({ top: Constants.SPACE_LG })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
