import { Constants } from '../../utils/Constants';

@Component
export struct AppBadge {
  @Prop count: number = 0;

  build() {
    if (this.count > 0) {
      Text(this.count > 99 ? '99+' : String(this.count))
        .fontSize(10)
        .fontColor('#FFFFFF')
        .padding({ left: 4, right: 4, top: 1, bottom: 1 })
        .backgroundColor(Constants.COLOR_DANGER)
        .borderRadius(10)
        .constraintSize({ minWidth: 16 })
        .textAlign(TextAlign.Center)
    }
  }
}
