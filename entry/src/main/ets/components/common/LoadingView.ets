import { Constants } from '../../utils/Constants';

@Component
export struct LoadingView {
  @Prop message: string = '加载中...';

  build() {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color(Constants.COLOR_PRIMARY)
      Blank().height(Constants.SPACE_LG)
      Text(this.message)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_HINT)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
