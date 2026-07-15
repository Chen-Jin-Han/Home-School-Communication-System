import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { ElementIcon } from './ElementIcon';

@Component
export struct AppNavBar {
  @Prop title: string = '';
  @Prop showBack: boolean = true;
  @BuilderParam rightContent?: () => void;

  build() {
    Row() {
      if (this.showBack) {
        Row() {
          ElementIcon({ name: 'Back', iconSize: 18, color: Constants.COLOR_TEXT_PRIMARY })

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
        .margin({ left: Constants.SPACE_MD })
        .onClick(() => {
          router.back();
        })
      } else {
        Blank().width(72 + Constants.SPACE_MD)
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
      .height(44)
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .constraintSize({ minWidth: 72, maxWidth: 120 })
      .margin({ right: Constants.SPACE_MD })
    }
    .width('100%')
    .height(Constants.NAV_BAR_HEIGHT)
    .backgroundColor(Constants.COLOR_SURFACE)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_BORDER })
  }
}
