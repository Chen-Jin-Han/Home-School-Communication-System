import { Constants } from '../../utils/Constants';

@Component
export struct StudentItem {
  @Prop studentName: string = '';
  @Prop className: string = '';
  @Prop status?: string;
  onTap?: () => void;

  build() {
    Row() {
      Column() {
        Text(this.studentName.charAt(0))
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_WHITE)
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.AVATAR_MD)
      .height(Constants.AVATAR_MD)
      .borderRadius(Constants.AVATAR_MD / 2)
      .backgroundColor(Constants.COLOR_PRIMARY)
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(this.studentName)
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
        if (this.className) {
          Text(this.className)
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
            .margin({ top: 2 })
        }
      }
      .margin({ left: Constants.SPACE_MD })
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      if (this.status) {
        Text(this.status)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_SUCCESS)
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .backgroundColor('#F6FFED')
          .borderRadius(10)
      }

      Image($r('sys.symbol.chevron_right'))
        .width(16)
        .height(16)
        .fillColor(Constants.COLOR_TEXT_HINT)
        .margin({ left: Constants.SPACE_SM })
    }
    .width('100%')
    .padding(Constants.SPACE_MD)
    .backgroundColor(Constants.COLOR_WHITE)
    .onClick(() => {
      if (this.onTap) {
        this.onTap();
      }
    })
    .border({
      width: { bottom: 0.5 },
      color: Constants.COLOR_DIVIDER,
    })
  }
}
