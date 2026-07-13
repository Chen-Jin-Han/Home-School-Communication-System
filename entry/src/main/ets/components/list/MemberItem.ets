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
        .backgroundColor(Constants.COLOR_TAG_PRIMARY_BG)
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
    switch (this.roleName) {
      case '教师':
      case '班主任':
        return Constants.COLOR_ROLE_TEACHER;
      case '学生':
        return Constants.COLOR_ROLE_STUDENT;
      case '家长':
        return Constants.COLOR_ROLE_PARENT;
      case '校长':
      case '领导':
        return Constants.COLOR_ROLE_LEADER;
      default:
        return Constants.COLOR_PRIMARY;
    }
  }
}
