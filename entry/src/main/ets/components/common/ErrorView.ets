import { Constants } from '../../utils/Constants';
import { ElementIcon } from './ElementIcon';

@Component
export struct ErrorView {
  @Prop message: string = '加载失败，请重试';
  onRetry?: () => void;

  build() {
    Column() {
      Row() {
        ElementIcon({ name: 'Error', iconSize: 28, color: Constants.COLOR_DANGER })
      }
        .width(56)
        .height(56)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .backgroundColor('#FEF2F2')
        .borderRadius(18)
        .margin({ bottom: Constants.SPACE_LG })
      Text(this.message)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .textAlign(TextAlign.Center)
        .padding({ left: Constants.SPACE_XL, right: Constants.SPACE_XL })
      Button('重试')
        .height(38)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_PRIMARY)
        .fontColor(Constants.COLOR_WHITE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .margin({ top: Constants.SPACE_LG })
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
