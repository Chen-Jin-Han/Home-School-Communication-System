import { Constants } from '../../utils/Constants';

@Component
export struct EmptyView {
  @Prop icon: string = '';
  @Prop message: string = '暂无数据';
  @Prop showAction: boolean = false;
  actionLabel: string = '刷新';
  onAction?: () => void;

  build() {
    Column() {
      Text('📭')
        .fontSize(48)
        .margin({ bottom: Constants.SPACE_LG })
      Text(this.message)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_HINT)
      if (this.showAction) {
        Blank().height(Constants.SPACE_LG)
        Button(this.actionLabel)
          .fontSize(Constants.FONT_MD)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .fontColor(Constants.COLOR_WHITE)
          .borderRadius(Constants.BUTTON_RADIUS)
          .onClick(() => {
            if (this.onAction) {
              this.onAction();
            }
          })
      }
    }
    .width('100%')
    .height('60%')
    .justifyContent(FlexAlign.Center)
  }
}
