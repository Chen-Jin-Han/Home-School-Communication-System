import { UserRole } from '../../models/UserModel';
import { UserStore } from '../../store/UserStore';
import { Constants } from '../../utils/Constants';
import { RouterUtil } from '../../utils/RouterUtil';
import { ElementIcon } from '../common/ElementIcon';

interface FeatureAction {
  title: string;
  desc: string;
  icon: string;
  type: string;
}

interface TabAction {
  title: string;
  icon: string;
}

@Component
export struct MobileWorkbench {
  @Prop role: UserRole = UserRole.PARENT;
  @State currentTab: number = 0;
  @Provide userStore: UserStore = UserStore.getInstance();

  build() {
    Column() {
      if (this.currentTab === 0) {
        this.Dashboard()
      } else if (this.role === UserRole.PARENT && this.currentTab === 1) {
        this.MessageTab()
      } else if (this.role === UserRole.PARENT && this.currentTab === 2) {
        this.ProfileTab()
      } else if (this.currentTab === 1) {
        this.SecondTab()
      } else if (this.currentTab === 2) {
        this.MessageTab()
      } else {
        this.ProfileTab()
      }

      this.BottomTabs()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  Dashboard() {
    Scroll() {
      Column() {
        this.Header()
        this.KpiStrip()
        this.SectionTitle('常用功能')
        this.FeatureGrid(this.primaryActions())
        this.SectionTitle(this.role === UserRole.LEADER ? '校园管理' : '校园服务')
        this.FeatureGrid(this.secondaryActions())
        Blank().height(18)
      }
      .width('100%')
      .padding({ bottom: 18 })
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }

  @Builder
  Header() {
    Column() {
      Row() {
        Column() {
          Text(this.greetingTitle())
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_WHITE)
          Text(this.greetingSubTitle())
            .fontSize(Constants.FONT_MD)
            .fontColor('#DCEBFF')
            .margin({ top: 6 })
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Image($r('app.media.app_logo'))
          .width(56)
          .height(56)
          .borderRadius(14)
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 30, bottom: 34 })
    .backgroundColor(Constants.COLOR_PRIMARY)
  }

  @Builder
  KpiStrip() {
    Row() {
      this.KpiItem('待办', this.role === UserRole.TEACHER ? '3' : '2')
      this.KpiItem('通知', '7')
      this.KpiItem(this.role === UserRole.LEADER ? '出勤率' : '本周', this.role === UserRole.LEADER ? '96%' : '正常')
    }
    .width('90%')
    .padding({ top: 16, bottom: 16 })
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .shadow({ radius: 14, color: '#1E3A8A14', offsetY: 6 })
    .margin({ left: 20, right: 20, top: -22 })
  }

  @Builder
  KpiItem(label: string, value: string) {
    Column() {
      Text(value)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
      Text(label)
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .margin({ top: 4 })
    }
    .layoutWeight(1)
  }

  @Builder
  SectionTitle(title: string) {
    Row() {
      Text(title)
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
      Blank()
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 24, bottom: 12 })
  }

  @Builder
  FeatureGrid(items: FeatureAction[]) {
    Grid() {
      ForEach(items, (item: FeatureAction) => {
        GridItem() {
          this.FeatureCard(item)
        }
      })
    }
    .columnsTemplate('1fr 1fr')
    .columnsGap(12)
    .rowsGap(12)
    .width('100%')
    .height(items.length > 4 ? 260 : 170)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  FeatureCard(item: FeatureAction) {
    Row() {
      this.WorkbenchIcon(item.icon, false, 42)

      Column() {
        Text(item.title)
          .fontSize(Constants.FONT_MD)
          .fontWeight(FontWeight.Medium)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
          .maxLines(1)
        Text(item.desc)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 4 })
          .maxLines(1)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })
      .layoutWeight(1)
    }
    .width('100%')
    .height(78)
    .padding({ left: 12, right: 10 })
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .onClick(() => {
      this.go(item.type);
    })
  }

  @Builder
  SecondTab() {
    Column() {
      this.SimpleTopBar(this.secondTabTitle(), true)
      Scroll() {
        Column() {
          this.FeatureGrid(this.secondTabActions())
          Blank().height(24)
        }
        .width('100%')
        .padding({ top: 16 })
      }
      .layoutWeight(1)
    }
    .layoutWeight(1)
  }

  @Builder
  MessageTab() {
    Column() {
      this.SimpleTopBar('消息', true)
      Column() {
        this.ListEntry('班级沟通', '家长、老师和学生的会话列表', 'chat')
        this.ListEntry('选择联系人', '发起新的家校沟通', 'contact')
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16 })
      .layoutWeight(1)
    }
    .layoutWeight(1)
  }

  @Builder
  ProfileTab() {
    Column() {
      this.SimpleTopBar('我的', true)
      Scroll() {
        Column() {
          Row() {
            Text((this.userStore.currentUser?.name || '?').substring(0, 1))
              .width(58)
              .height(58)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_WHITE)
              .textAlign(TextAlign.Center)
              .backgroundColor(Constants.COLOR_PRIMARY)
              .borderRadius(14)

            Column() {
              Text(this.userStore.currentUser?.name || '未登录')
                .fontSize(Constants.FONT_XL)
                .fontWeight(FontWeight.Bold)
                .fontColor(Constants.COLOR_TEXT_PRIMARY)
              Text(this.roleLabel())
                .fontSize(Constants.FONT_MD)
                .fontColor(Constants.COLOR_TEXT_HINT)
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 14 })
            .layoutWeight(1)
          }
          .width('100%')
          .padding(18)
          .backgroundColor(Constants.COLOR_WHITE)
          .borderRadius(Constants.CARD_RADIUS)
          .border({ width: 1, color: Constants.COLOR_BORDER })
          .margin({ bottom: 14 })

          this.ListEntry('个人信息', '查看并维护基础资料', 'profile')
          this.ListEntry('学校信息', '学校介绍和联系方式', 'school')
          this.ListEntry('组织架构', '年级、班级和成员结构', 'org')

          Button('退出登录')
            .width('100%')
            .height(46)
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_DANGER)
            .backgroundColor(Constants.COLOR_WHITE)
            .borderRadius(Constants.CARD_RADIUS)
            .border({ width: 1, color: Constants.COLOR_BORDER })
            .margin({ top: 18 })
            .onClick(async () => {
              await this.userStore.logout();
              RouterUtil.toLogin();
            })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 16, bottom: 24 })
      }
      .layoutWeight(1)
    }
    .layoutWeight(1)
  }

  @Builder
  SimpleTopBar(title: string, showBack: boolean = false) {
    Row() {
      if (showBack) {
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
        .onClick(() => {
          this.currentTab = 0;
        })
      }

      Text(title)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .layoutWeight(1)

      Blank()
    }
    .width('100%')
    .height(56)
    .padding({ left: 20, right: 20 })
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  ListEntry(title: string, desc: string, type: string) {
    Row() {
      this.WorkbenchIcon(this.iconForType(type), false, 42)

      Column() {
        Text(title)
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
          .fontWeight(FontWeight.Medium)
        Text(desc)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)

      ElementIcon({ name: 'ChevronRight', iconSize: 18, color: Constants.COLOR_TEXT_HINT })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .margin({ bottom: 10 })
    .onClick(() => {
      this.go(type);
    })
  }

  @Builder
  BottomTabs() {
    Row() {
      ForEach(this.tabs(), (item: TabAction, index: number) => {
        Column() {
          this.TabIcon(item.icon, index)

          Text(item.title)
            .fontSize(11)
            .fontColor(this.currentTab === index ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT)
            .margin({ top: 3 })
        }
        .layoutWeight(1)
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentTab = index;
        })
      })
    }
    .width('100%')
    .height(Constants.TAB_BAR_HEIGHT)
    .backgroundColor(Constants.COLOR_WHITE)
    .border({ width: { top: 0.5 }, color: Constants.COLOR_BORDER })
  }

  @Builder
  WorkbenchIcon(icon: string, active: boolean = false, size: number = 38) {
    Row() {
      ElementIcon({
        name: this.elementIconName(icon),
        iconSize: 21,
        color: active ? Constants.COLOR_WHITE : Constants.COLOR_PRIMARY,
      })
    }
    .width(size)
    .height(size)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(active ? Constants.COLOR_PRIMARY : Constants.COLOR_PRIMARY_SOFT)
    .borderRadius(12)
    .border({ width: 1, color: active ? Constants.COLOR_PRIMARY : '#D8E6FF' })
  }

  @Builder
  TabIcon(icon: string, tabIndex: number) {
    Row() {
      ElementIcon({
        name: this.elementIconName(icon),
        iconSize: 20,
        color: this.currentTab === tabIndex ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT,
      })
    }
    .width(36)
    .height(28)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(this.currentTab === tabIndex ? Constants.COLOR_PRIMARY_SOFT : Constants.COLOR_WHITE)
    .borderRadius(14)
  }

  private greetingTitle(): string {
    const name = this.userStore.currentUser?.name || '同学';
    if (this.role === UserRole.TEACHER) {
      return `${name}老师`;
    }
    if (this.role === UserRole.LEADER) {
      return this.userStore.currentUser?.position || '校园管理';
    }
    return `你好，${name}`;
  }

  private greetingSubTitle(): string {
    if (this.role === UserRole.PARENT) {
      return `关注 ${this.userStore.currentUser?.childNames?.[0] || '孩子'} 的校园动态`;
    }
    if (this.role === UserRole.STUDENT) {
      return this.userStore.currentUser?.className || '查看学习任务和校园服务';
    }
    if (this.role === UserRole.TEACHER) {
      return `${this.userStore.currentUser?.className || '班级'} ${this.userStore.currentUser?.subject || ''}`;
    }
    return this.userStore.currentUser?.name || '掌握校园运行情况';
  }

  private roleLabel(): string {
    if (this.role === UserRole.PARENT) {
      return '家长';
    }
    if (this.role === UserRole.STUDENT) {
      return '学生';
    }
    if (this.role === UserRole.TEACHER) {
      return '教师';
    }
    return '领导';
  }

  private tabs(): TabAction[] {
    if (this.role === UserRole.PARENT) {
      return [{ title: '首页', icon: 'home' }, { title: '消息', icon: 'message' }, { title: '我的', icon: 'profile' }];
    }
    if (this.role === UserRole.STUDENT) {
      return [{ title: '首页', icon: 'home' }, { title: '作业', icon: 'homework' }, { title: '消息', icon: 'message' }, { title: '我的', icon: 'profile' }];
    }
    if (this.role === UserRole.TEACHER) {
      return [{ title: '首页', icon: 'home' }, { title: '班级', icon: 'class' }, { title: '消息', icon: 'message' }, { title: '我的', icon: 'profile' }];
    }
    return [{ title: '首页', icon: 'home' }, { title: '发布', icon: 'publish' }, { title: '消息', icon: 'message' }, { title: '我的', icon: 'profile' }];
  }

  private primaryActions(): FeatureAction[] {
    if (this.role === UserRole.TEACHER) {
      return [
        { title: '发布通知', desc: '班级通知公告', icon: 'publish', type: 'publish' },
        { title: '布置作业', desc: '创建课后任务', icon: 'homework', type: 'assignHomework' },
        { title: '学生名单', desc: '班级成员管理', icon: 'students', type: 'students' },
        { title: '学生评价', desc: '记录成长表现', icon: 'evaluation', type: 'evaluation' },
      ];
    }
    if (this.role === UserRole.LEADER) {
      return [
        { title: '发布通知', desc: '全校通知公告', icon: 'publish', type: 'publish' },
        { title: '组织架构', desc: '查看校园结构', icon: 'org', type: 'org' },
        { title: '学生名单', desc: '学生信息总览', icon: 'students', type: 'students' },
        { title: '我的发布', desc: '发布记录管理', icon: 'published', type: 'published' },
      ];
    }
    return [
      { title: '通知公告', desc: '校园通知速览', icon: 'notice', type: 'notice' },
      { title: '课后作业', desc: '查看学习任务', icon: 'homework', type: 'homework' },
      { title: '成绩报告', desc: '掌握学习表现', icon: 'grade', type: 'grade' },
      { title: '考勤记录', desc: '到校离校状态', icon: 'attendance', type: 'attendance' },
    ];
  }

  private secondaryActions(): FeatureAction[] {
    if (this.role === UserRole.TEACHER || this.role === UserRole.LEADER) {
      return [
        { title: '作业列表', desc: '查看作业进度', icon: 'homework', type: 'homework' },
        { title: '考勤管理', desc: '学生出勤记录', icon: 'attendance', type: 'attendance' },
        { title: '成绩管理', desc: '成绩报告查询', icon: 'grade', type: 'grade' },
        { title: '校园活动', desc: '活动安排查看', icon: 'activity', type: 'activity' },
        { title: '学校信息', desc: '校园基础资料', icon: 'school', type: 'school' },
        { title: '消息沟通', desc: '进入会话列表', icon: 'message', type: 'chat' },
      ];
    }
    return [
      { title: '健康档案', desc: '体检健康记录', icon: 'health', type: 'health' },
      { title: '学生评价', desc: '成长表现反馈', icon: 'evaluation', type: 'evaluation' },
      { title: '校园活动', desc: '报名与详情', icon: 'activity', type: 'activity' },
      { title: '学校信息', desc: '学校介绍', icon: 'school', type: 'school' },
    ];
  }

  private secondTabTitle(): string {
    if (this.role === UserRole.STUDENT) {
      return '作业';
    }
    if (this.role === UserRole.TEACHER) {
      return '班级';
    }
    if (this.role === UserRole.LEADER) {
      return '发布';
    }
    return '消息';
  }

  private secondTabActions(): FeatureAction[] {
    if (this.role === UserRole.STUDENT) {
      return [
        { title: '作业列表', desc: '查看全部作业', icon: 'homework', type: 'homework' },
        { title: '成绩报告', desc: '查看考试成绩', icon: 'grade', type: 'grade' },
      ];
    }
    if (this.role === UserRole.TEACHER) {
      return [
        { title: '学生名单', desc: '班级成员', icon: 'students', type: 'students' },
        { title: '考勤管理', desc: '学生出勤', icon: 'attendance', type: 'attendance' },
        { title: '成绩管理', desc: '成绩报告', icon: 'grade', type: 'grade' },
        { title: '写评价', desc: '选择学生评价', icon: 'evaluation', type: 'students' },
      ];
    }
    if (this.role === UserRole.LEADER) {
      return [
        { title: '发布通知', desc: '创建通知公告', icon: 'publish', type: 'publish' },
        { title: '我的发布', desc: '查看发布记录', icon: 'published', type: 'published' },
        { title: '组织架构', desc: '校园结构', icon: 'org', type: 'org' },
      ];
    }
    return [{ title: '消息列表', desc: '进入会话', icon: 'message', type: 'chat' }];
  }

  private iconForType(type: string): string {
    if (type === 'chat' || type === 'contact') {
      return 'message';
    }
    if (type === 'assignHomework') {
      return 'homework';
    }
    if (type === 'students') {
      return 'students';
    }
    if (type === 'published') {
      return 'published';
    }
    if (type === 'profile') {
      return 'profile';
    }
    return type;
  }

  private elementIconName(icon: string): string {
    if (icon === 'home') {
      return 'Home';
    }
    if (icon === 'message') {
      return 'Message';
    }
    if (icon === 'profile') {
      return 'User';
    }
    if (icon === 'notice') {
      return 'Bell';
    }
    if (icon === 'publish') {
      return 'Edit';
    }
    if (icon === 'published') {
      return 'Archive';
    }
    if (icon === 'homework') {
      return 'Document';
    }
    if (icon === 'grade') {
      return 'Chart';
    }
    if (icon === 'attendance') {
      return 'Check';
    }
    if (icon === 'health') {
      return 'Health';
    }
    if (icon === 'evaluation') {
      return 'Star';
    }
    if (icon === 'activity') {
      return 'Calendar';
    }
    if (icon === 'school') {
      return 'School';
    }
    if (icon === 'org' || icon === 'class' || icon === 'students') {
      return 'Team';
    }
    return 'Grid';
  }

  private go(type: string): void {
    if (type === 'notice') {
      RouterUtil.toNotificationList();
    } else if (type === 'homework') {
      RouterUtil.toHomeworkList();
    } else if (type === 'assignHomework') {
      RouterUtil.toAssignHomework();
    } else if (type === 'grade') {
      RouterUtil.toGradeList(this.userStore.getStudentId());
    } else if (type === 'attendance') {
      RouterUtil.toAttendanceList(this.userStore.getStudentId());
    } else if (type === 'health') {
      RouterUtil.toHealthRecordList(this.userStore.getStudentId());
    } else if (type === 'evaluation') {
      RouterUtil.toEvaluationList(this.userStore.getStudentId());
    } else if (type === 'activity') {
      RouterUtil.toActivityList();
    } else if (type === 'school') {
      RouterUtil.toSchoolInfo();
    } else if (type === 'students') {
      RouterUtil.toStudentList(this.userStore.currentUser?.classId);
    } else if (type === 'publish') {
      RouterUtil.toPublishNotice();
    } else if (type === 'published') {
      RouterUtil.toMyPublished();
    } else if (type === 'org') {
      RouterUtil.toOrgStructure();
    } else if (type === 'chat') {
      RouterUtil.toConversationList();
    } else if (type === 'contact') {
      RouterUtil.toSelectContact();
    } else if (type === 'profile') {
      RouterUtil.toPersonalProfile();
    }
  }
}
