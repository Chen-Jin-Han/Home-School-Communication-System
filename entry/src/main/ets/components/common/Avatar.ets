import { Constants } from '../../utils/Constants';

@Component
export struct Avatar {
  @Prop src: string = '';
  @Prop name: string = '';
  @Prop avatarSize: number = Constants.AVATAR_MD;
  @Prop showBorder: boolean = false;

  build() {
    Column() {
      if (this.src) {
        Image(this.src)
          .width(this.avatarSize)
          .height(this.avatarSize)
          .borderRadius(this.avatarSize / 2)
          .objectFit(ImageFit.Cover)
      } else {
        Text(this.name ? this.name.charAt(0).toUpperCase() : '?')
          .fontSize(this.avatarSize * 0.45)
          .fontColor(Constants.COLOR_WHITE)
          .fontWeight(FontWeight.Bold)
      }
    }
    .width(this.avatarSize)
    .height(this.avatarSize)
    .borderRadius(this.avatarSize / 2)
    .backgroundColor(Constants.COLOR_PRIMARY)
    .justifyContent(FlexAlign.Center)
    .border({
      width: this.showBorder ? 2 : 0,
      color: Constants.COLOR_WHITE,
    })
  }
}
