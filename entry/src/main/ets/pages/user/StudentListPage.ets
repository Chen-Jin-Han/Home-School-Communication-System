import { Constants } from '../../utils/Constants';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';

@Entry
@Component
struct StudentListPage {
  @Provide userStore: UserStore = UserStore.getInstance();

  build() {
    Column() {
      AppNavBar({ title: this.userStore.currentUser?.className || '学生名单' })
      Scroll() {
        Column() {
          // Mock students for demo
          ForEach(
            ['张小伟', '李小萌', '王小明', '赵小红', '陈小华'],
            (name: string) => {
              Row() {
                Column() {
                  Text(name.charAt(0)).fontSize(18).fontColor('#FFF').fontWeight(FontWeight.Bold)
                }
                .width(40).height(40).borderRadius(20).backgroundColor('#4ECDC4').justifyContent(FlexAlign.Center)

                Text(name).fontSize(Constants.FONT_LG).fontColor(Constants.COLOR_TEXT_PRIMARY).margin({ left: Constants.SPACE_MD }).layoutWeight(1)

                Image($r('sys.symbol.chevron_right')).width(16).height(16).fillColor(Constants.COLOR_TEXT_HINT)
              }
              .width('100%')
              .padding(Constants.SPACE_MD)
              .backgroundColor(Constants.COLOR_WHITE)
              .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
              .onClick(() => {
                // Navigate to student-specific views
              })
            }
          )
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }
}
