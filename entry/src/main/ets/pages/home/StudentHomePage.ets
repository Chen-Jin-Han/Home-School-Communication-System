import { UserStore } from '../../store/UserStore';
import { Constants } from '../../utils/Constants';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { Avatar } from '../../components/common/Avatar';

@Entry
@Component
struct StudentHomePage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State currentTab: number = 0;

  build() {
    Column() {
      if (this.currentTab === 0) {
        this.HomeTab();
      } else if (this.currentTab === 1) {
        this.HomeworkTab();
      } else if (this.currentTab === 2) {
        this.ChatTab();
      } else {
        this.ProfileTab();
      }

      Row() {
        this.TabButton(0, '🏠', '首页')
        this.TabButton(1, '📝', '作业')
        this.TabButton(2, '💬', '消息')
        this.TabButton(3, '👤', '我的')
      }
      .width('100%')
      .height(Constants.TAB_BAR_HEIGHT)
      .backgroundColor(Constants.COLOR_WHITE)
      .border({ width: { top: 0.5 }, color: Constants.COLOR_BORDER })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  TabButton(index: number, icon: string, label: string) {
    Column() {
      Text(icon).fontSize(22)
      Text(label)
        .fontSize(11)
        .fontColor(index === this.currentTab ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT)
        .margin({ top: 2 })
    }
    .layoutWeight(1)
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => { this.currentTab = index; })
  }

  @Builder
  HomeTab() {
    Scroll() {
      Column() {
        Row() {
          Column() {
            Text(`你好, ${this.userStore.currentUser?.name}`)
              .fontSize(Constants.FONT_XXL)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_WHITE)
            Text(`${this.userStore.currentUser?.className || ''}`)
              .fontSize(Constants.FONT_MD)
              .fontColor('#FFFFFFCC')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          Blank()
        }
        .width('100%')
        .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_XL, bottom: Constants.SPACE_XL })
        .backgroundColor(Constants.COLOR_PRIMARY)

        // Quick actions
        Row() {
          this.QuickAction('🔔', '通知', () => { RouterUtil.toNotificationList(); })
          this.QuickAction('📝', '作业', () => { RouterUtil.toHomeworkList(); })
          this.QuickAction('📊', '成绩', () => { RouterUtil.toGradeList(); })
          this.QuickAction('✅', '考勤', () => { RouterUtil.toAttendanceList(); })
        }
        .width('100%')
        .padding(Constants.SPACE_MD)
        .backgroundColor(Constants.COLOR_WHITE)
        .borderRadius(Constants.CARD_RADIUS)
        .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: -20 })

        // Module shortcuts
        this.SectionTitle('校园服务')

        Row() {
          this.ShortcutCard('🏫', '学校信息', () => { RouterUtil.toSchoolInfo(); })
          this.ShortcutCard('🎉', '学生活动', () => { RouterUtil.toActivityList(); })
        }
        .width('100%')
        .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG })
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          this.ShortcutCard('❤️', '健康档案', () => { RouterUtil.toHealthRecordList(); })
          this.ShortcutCard('⭐', '我的评价', () => { RouterUtil.toEvaluationList(); })
        }
        .width('100%')
        .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG })
        .justifyContent(FlexAlign.SpaceBetween)

        Blank().height(20)
      }
      .width('100%')
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }

  @Builder
  SectionTitle(title: string) {
    Text(title)
      .fontSize(Constants.FONT_LG)
      .fontWeight(FontWeight.Bold)
      .fontColor(Constants.COLOR_TEXT_PRIMARY)
      .width('100%')
      .padding({ left: Constants.SPACE_LG, top: Constants.SPACE_XL, bottom: Constants.SPACE_MD })
  }

  @Builder
  QuickAction(icon: string, label: string, action: () => void) {
    Column() {
      Text(icon).fontSize(28)
      Text(label).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_SECONDARY).margin({ top: 4 })
    }
    .layoutWeight(1)
    .onClick(action)
  }

  @Builder
  ShortcutCard(icon: string, label: string, action: () => void) {
    Row() {
      Text(icon).fontSize(24)
      Text(label).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_PRIMARY).margin({ left: Constants.SPACE_SM })
    }
    .width('47%')
    .padding(Constants.SPACE_MD)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .margin({ top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
    .onClick(action)
  }

  @Builder
  HomeworkTab() {
    Column() {
      AppNavBar({ title: '作业' })
      Row() {
        Text('作业列表')
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_TEXT_HINT)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .onClick(() => { RouterUtil.toHomeworkList(); })
    }
    .layoutWeight(1)
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  ChatTab() {
    Column() {
      AppNavBar({ title: '消息' })
      Row() {
        Text('消息列表')
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_TEXT_HINT)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .onClick(() => { RouterUtil.toConversationList(); })
    }
    .layoutWeight(1)
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  ProfileTab() {
    Column() {
      AppNavBar({ title: '我的' })
      Scroll() {
        Column() {
          Row() {
            Avatar({ name: this.userStore.currentUser?.name || '?', avatarSize: Constants.AVATAR_LG })
            Column() {
              Text(this.userStore.currentUser?.name || '')
                .fontSize(Constants.FONT_XL)
                .fontWeight(FontWeight.Bold)
              Text('学生')
                .fontSize(Constants.FONT_MD)
                .fontColor(Constants.COLOR_TEXT_HINT)
                .margin({ top: 4 })
            }
            .margin({ left: Constants.SPACE_MD })
            .alignItems(HorizontalAlign.Start)
            Blank()
          }
          .width('100%')
          .padding(Constants.SPACE_LG)
          .backgroundColor(Constants.COLOR_WHITE)

          this.ProfileMenuItem('个人信息', () => { RouterUtil.toPersonalProfile(); })
          this.ProfileMenuItem('学校信息', () => { RouterUtil.toSchoolInfo(); })

          Blank().height(40)

          Button('退出登录')
            .width('90%')
            .height(44)
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_DANGER)
            .backgroundColor(Constants.COLOR_WHITE)
            .borderRadius(Constants.BUTTON_RADIUS)
            .onClick(async () => {
              await this.userStore.logout();
              RouterUtil.toLogin();
            })
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .layoutWeight(1)
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  ProfileMenuItem(label: string, action: () => void) {
    Row() {
      Text(label).fontSize(Constants.FONT_LG).layoutWeight(1)
      Image($r('sys.symbol.chevron_right')).width(16).height(16).fillColor(Constants.COLOR_TEXT_HINT)
    }
    .width('100%')
    .padding(Constants.SPACE_LG)
    .backgroundColor(Constants.COLOR_WHITE)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
    .onClick(action)
  }
}
