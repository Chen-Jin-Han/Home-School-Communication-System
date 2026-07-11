import { Constants } from '../../utils/Constants';

@Component
export struct MemberItem {
  @Prop memberName: string = '';
  @Prop roleName: string = '';
  onTap?: () => void;

  build() {
    Row() {
      Column() {
        Text(this.memberName.charAt(0))
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_WHITE)
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.AVATAR_MD)
      .height(Constants.AVATAR_MD)
      .borderRadius(Constants.AVATAR_MD / 2)
      .backgroundColor(this.getRoleColor())
      .justifyContent(FlexAlign.Center)

      Text(this.memberName)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .margin({ left: Constants.SPACE_MD })
        .layoutWeight(1)

      Text(this.roleName)
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_PRIMARY)
        .padding({ left: 8, right: 8, top: 3, bottom: 3 })
        .backgroundColor('#E6F7FF')
        .borderRadius(10)
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

  getRoleColor(): string {
    const colors = {
      '教师': '#FF6B6B',
      '班主任': '#FF6B6B',
      '学生': '#4ECDC4',
      '家长': '#45B7D1',
      '校长': '#96CEB4',
    };
    return colors[this.roleName] || Constants.COLOR_PRIMARY;
  }
}
