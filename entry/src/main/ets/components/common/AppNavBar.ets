import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';

@Component
export struct AppNavBar {
  @Prop title: string = '';
  @Prop showBack: boolean = true;
  @BuilderParam rightContent?: () => void;

  build() {
    Row() {
      if (this.showBack) {
        Image($r('sys.symbol.chevron_left'))
          .width(Constants.ICON_SIZE)
          .height(Constants.ICON_SIZE)
          .fillColor(Constants.COLOR_TEXT_PRIMARY)
          .margin({ left: Constants.SPACE_MD })
          .onClick(() => {
            router.back();
          })
      }
      Text(this.title)
        .fontSize(Constants.FONT_XL)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .margin({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
      if (this.rightContent) {
        this.rightContent();
      } else {
        Row().width(Constants.ICON_SIZE + Constants.SPACE_MD * 2);
      }
    }
    .width('100%')
    .height(Constants.NAV_BAR_HEIGHT)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(0)
  }
}
