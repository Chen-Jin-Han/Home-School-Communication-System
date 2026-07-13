import { Constants } from '../../utils/Constants';
import { ElementIcon } from './ElementIcon';

@Component
export struct EmptyView {
  @Prop icon: string = 'Empty';
  @Prop message: string = '暂无数据';
  @Prop showAction: boolean = false;
  actionLabel: string = '刷新';
  onAction?: () => void;

  build() {
    Column() {
      Row() {
        ElementIcon({ name: this.icon, iconSize: 28, color: Constants.COLOR_TEXT_HINT })
      }
        .width(56)
        .height(56)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .backgroundColor(Constants.COLOR_DIVIDER)
        .borderRadius(18)
        .margin({ bottom: Constants.SPACE_LG })
      Text(this.message)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .textAlign(TextAlign.Center)
      if (this.showAction) {
        Button(this.actionLabel)
          .height(38)
          .fontSize(Constants.FONT_MD)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .fontColor(Constants.COLOR_WHITE)
          .borderRadius(Constants.BUTTON_RADIUS)
          .margin({ top: Constants.SPACE_LG })
          .onClick(() => {
            if (this.onAction) {
              this.onAction();
            }
          })
      }
    }
    .width('100%')
    .height('60%')
    .padding({ left: Constants.SPACE_XL, right: Constants.SPACE_XL })
    .justifyContent(FlexAlign.Center)
  }
}
