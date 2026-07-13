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
        Row() {
          Image($r('sys.symbol.chevron_left'))
            .width(22)
            .height(22)
            .fillColor(Constants.COLOR_TEXT_PRIMARY)
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .borderRadius(20)
        .onClick(() => {
          router.back();
        })
      } else {
        Blank().width(40)
      }

      Text(this.title)
        .fontSize(Constants.FONT_XL)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row() {
        if (this.rightContent) {
          this.rightContent();
        }
      }
      .width(40)
      .height(40)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(Constants.NAV_BAR_HEIGHT)
    .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
    .backgroundColor(Constants.COLOR_SURFACE)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_BORDER })
  }
}
