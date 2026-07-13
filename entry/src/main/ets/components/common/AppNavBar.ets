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
          Text('<')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .width(18)
            .textAlign(TextAlign.Center)

          Text('返回')
            .fontSize(Constants.FONT_MD)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .margin({ left: 2 })
        }
        .width(72)
        .height(44)
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .borderRadius(22)
        .onClick(() => {
          router.back();
        })
      } else {
        Blank().width(72)
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
      .width(72)
      .height(44)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(Constants.NAV_BAR_HEIGHT)
    .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
    .backgroundColor(Constants.COLOR_SURFACE)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_BORDER })
  }
}
