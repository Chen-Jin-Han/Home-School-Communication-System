import { Constants } from '../../utils/Constants';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { Avatar } from '../../components/common/Avatar';

@Entry
@Component
struct PersonalProfilePage {
  @Provide userStore: UserStore = UserStore.getInstance();

  build() {
    Column() {
      AppNavBar({ title: '个人信息' })
      Scroll() {
        Column() {
          Row() {
            Avatar({ name: this.userStore.currentUser?.name || '?', avatarSize: Constants.AVATAR_LG })
            Column() {
              Text(this.userStore.currentUser?.name || '').fontSize(Constants.FONT_XL).fontWeight(FontWeight.Bold)
              Text(this.getRoleLabel()).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_HINT).margin({ top: 4 })
            }
            .margin({ left: Constants.SPACE_MD })
            .alignItems(HorizontalAlign.Start)
            Blank()
          }
          .width('100%')
          .padding(Constants.SPACE_LG)
          .backgroundColor(Constants.COLOR_WHITE)

          this.FieldRow('手机号', this.userStore.currentUser?.phone || '')
          this.FieldRow('学校', this.userStore.currentUser?.schoolName || '')
          if (this.userStore.currentUser?.className) {
            this.FieldRow('班级', this.userStore.currentUser.className)
          }
          if (this.userStore.currentUser?.subject) {
            this.FieldRow('科目', this.userStore.currentUser.subject)
          }
          if (this.userStore.currentUser?.position) {
            this.FieldRow('职务', this.userStore.currentUser.position)
          }
          if (this.userStore.isParent() && this.userStore.currentUser?.childNames) {
            this.FieldRow('子女', this.userStore.currentUser.childNames.join(', '))
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  getRoleLabel(): string {
    const store = this.userStore;
    if (store.isParent()) return '家长';
    if (store.isStudent()) return '学生';
    if (store.isTeacher()) return '教师';
    if (store.isLeader()) return '领导';
    return '';
  }

  @Builder
  FieldRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_HINT).width(80)
      Text(value).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_PRIMARY).layoutWeight(1)
    }
    .width('100%')
    .padding(Constants.SPACE_LG)
    .backgroundColor(Constants.COLOR_WHITE)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
  }
}
