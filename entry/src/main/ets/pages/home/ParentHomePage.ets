import { UserStore } from '../../store/UserStore';
import { Constants } from '../../utils/Constants';
import { RouterUtil } from '../../utils/RouterUtil';
import { AttendanceService } from '../../services/AttendanceService';
import { NoticeService } from '../../services/NoticeService';
import { AttendanceRecord } from '../../models/AttendanceModel';
import { Notice } from '../../models/NoticeModel';
import { AttendanceCard } from '../../components/card/AttendanceCard';
import { NoticeCard } from '../../components/card/NoticeCard';
import { AppNavBar } from '../../components/common/AppNavBar';
import { Avatar } from '../../components/common/Avatar';

@Entry
@Component
struct ParentHomePage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State currentTab: number = 0;
  @State todayAttendance: AttendanceRecord | null = null;
  @State notices: Notice[] = [];

  async aboutToAppear(): Promise<void> {
    // Load initial data
    const childId = this.userStore.getChildId();
    if (childId) {
      const ar = await AttendanceService.getTodayStatus(childId);
      this.todayAttendance = ar.data;
    }
    const nr = await NoticeService.getList({ page: 1, pageSize: 3 });
    this.notices = nr.data.list;
  }

  build() {
    Column() {
      // Content area
      if (this.currentTab === 0) {
        this.HomeDashboard();
      } else if (this.currentTab === 1) {
        this.ChatTab();
      } else {
        this.ProfileTab();
      }

      // Bottom tab bar
      Row() {
        this.TabButton(0, '🏠', '首页')
        this.TabButton(1, '💬', '消息', this.userStore.unreadChatCount)
        this.TabButton(2, '👤', '我的')
      }
      .width('100%')
      .height(Constants.TAB_BAR_HEIGHT)
      .backgroundColor(Constants.COLOR_WHITE)
      .border({
        width: { top: 0.5 },
        color: Constants.COLOR_BORDER,
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  TabButton(index: number, icon: string, label: string, badge?: number) {
    Column() {
      Text(icon)
        .fontSize(22)
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
  HomeDashboard() {
    Scroll() {
      Column() {
        // Header
        Row() {
          Column() {
            Text(`你好, ${this.userStore.currentUser?.name}`)
              .fontSize(Constants.FONT_XXL)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_WHITE)
            if (this.userStore.currentUser?.childNames) {
              Text(`孩子: ${this.userStore.currentUser.childNames.join(', ')}`)
                .fontSize(Constants.FONT_MD)
                .fontColor('#FFFFFFCC')
                .margin({ top: 4 })
            }
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
          this.QuickAction('❤️', '健康', () => { RouterUtil.toHealthRecordList(); })
        }
        .width('100%')
        .padding(Constants.SPACE_MD)
        .backgroundColor(Constants.COLOR_WHITE)
        .borderRadius(Constants.CARD_RADIUS)
        .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: -20 })

        // Today attendance
        if (this.todayAttendance) {
          Text('今日考勤')
            .fontSize(Constants.FONT_LG)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .width('100%')
            .padding({ left: Constants.SPACE_LG, top: Constants.SPACE_XL })
          AttendanceCard({
            record: this.todayAttendance,
            studentName: this.userStore.currentUser?.childNames?.[0] || '',
            onTap: () => { RouterUtil.toAttendanceList(); }
          })
        }

        // Latest notices
        Text('最新通知')
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
          .width('100%')
          .padding({ left: Constants.SPACE_LG, top: Constants.SPACE_XL })

        ForEach(this.notices, (notice: Notice) => {
          NoticeCard({ notice: notice, onTap: () => { RouterUtil.toNotificationDetail(notice.id); } })
        })

        Row() {
          Text('查看全部通知')
            .fontSize(Constants.FONT_MD)
            .fontColor(Constants.COLOR_PRIMARY)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding(Constants.SPACE_MD)
        .onClick(() => { RouterUtil.toNotificationList(); })

        Blank().height(20)
      }
      .width('100%')
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
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
          // User info
          Row() {
            Avatar({ name: this.userStore.currentUser?.name || '?', avatarSize: Constants.AVATAR_LG })
            Column() {
              Text(this.userStore.currentUser?.name || '')
                .fontSize(Constants.FONT_XL)
                .fontWeight(FontWeight.Bold)
                .fontColor(Constants.COLOR_TEXT_PRIMARY)
              Text('家长')
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

          // Menu items
          this.ProfileMenuItem('个人信息', () => { RouterUtil.toPersonalProfile(); })
          this.ProfileMenuItem('学校信息', () => { RouterUtil.toSchoolInfo(); })
          this.ProfileMenuItem('组织架构', () => { RouterUtil.toOrgStructure(); })
          this.ProfileMenuItem('关于我们', () => {})

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
      Text(label)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .layoutWeight(1)
      Image($r('sys.symbol.chevron_right'))
        .width(16)
        .height(16)
        .fillColor(Constants.COLOR_TEXT_HINT)
    }
    .width('100%')
    .padding(Constants.SPACE_LG)
    .backgroundColor(Constants.COLOR_WHITE)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
    .onClick(action)
  }
}
