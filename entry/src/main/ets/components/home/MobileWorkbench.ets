import { UserRole } from '../../models/UserModel';
import { UserStore } from '../../store/UserStore';
import { Constants } from '../../utils/Constants';
import { RouterUtil } from '../../utils/RouterUtil';

interface FeatureAction {
  title: string;
  desc: string;
  mark: string;
  type: string;
}

interface TabAction {
  title: string;
  mark: string;
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
      Text(item.mark)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_PRIMARY)
        .width(38)
        .height(38)
        .textAlign(TextAlign.Center)
        .backgroundColor('#EFF6FF')
        .borderRadius(10)

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
          Text('<')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .width(18)
            .textAlign(TextAlign.Center)

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
      .layoutWeight(1)

      Text('>')
        .fontSize(22)
        .fontColor(Constants.COLOR_TEXT_HINT)
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
          Text(item.mark)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.currentTab === index ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT)
          Text(item.title)
            .fontSize(11)
            .fontColor(this.currentTab === index ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT)
            .margin({ top: 2 })
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
      return [{ title: '首页', mark: '首' }, { title: '消息', mark: '讯' }, { title: '我的', mark: '我' }];
    }
    if (this.role === UserRole.STUDENT) {
      return [{ title: '首页', mark: '首' }, { title: '作业', mark: '作' }, { title: '消息', mark: '讯' }, { title: '我的', mark: '我' }];
    }
    if (this.role === UserRole.TEACHER) {
      return [{ title: '首页', mark: '首' }, { title: '班级', mark: '班' }, { title: '消息', mark: '讯' }, { title: '我的', mark: '我' }];
    }
    return [{ title: '首页', mark: '首' }, { title: '发布', mark: '发' }, { title: '消息', mark: '讯' }, { title: '我的', mark: '我' }];
  }

  private primaryActions(): FeatureAction[] {
    if (this.role === UserRole.TEACHER) {
      return [
        { title: '发布通知', desc: '班级通知公告', mark: '通', type: 'publish' },
        { title: '布置作业', desc: '创建课后任务', mark: '作', type: 'assignHomework' },
        { title: '学生名单', desc: '班级成员管理', mark: '名', type: 'students' },
        { title: '学生评价', desc: '记录成长表现', mark: '评', type: 'evaluation' },
      ];
    }
    if (this.role === UserRole.LEADER) {
      return [
        { title: '发布通知', desc: '全校通知公告', mark: '通', type: 'publish' },
        { title: '组织架构', desc: '查看校园结构', mark: '组', type: 'org' },
        { title: '学生名单', desc: '学生信息总览', mark: '名', type: 'students' },
        { title: '我的发布', desc: '发布记录管理', mark: '发', type: 'published' },
      ];
    }
    return [
      { title: '通知公告', desc: '校园通知速览', mark: '通', type: 'notice' },
      { title: '课后作业', desc: '查看学习任务', mark: '作', type: 'homework' },
      { title: '成绩报告', desc: '掌握学习表现', mark: '绩', type: 'grade' },
      { title: '考勤记录', desc: '到校离校状态', mark: '勤', type: 'attendance' },
    ];
  }

  private secondaryActions(): FeatureAction[] {
    if (this.role === UserRole.TEACHER || this.role === UserRole.LEADER) {
      return [
        { title: '作业列表', desc: '查看作业进度', mark: '作', type: 'homework' },
        { title: '考勤管理', desc: '学生出勤记录', mark: '勤', type: 'attendance' },
        { title: '成绩管理', desc: '成绩报告查询', mark: '绩', type: 'grade' },
        { title: '校园活动', desc: '活动安排查看', mark: '活', type: 'activity' },
        { title: '学校信息', desc: '校园基础资料', mark: '校', type: 'school' },
        { title: '消息沟通', desc: '进入会话列表', mark: '讯', type: 'chat' },
      ];
    }
    return [
      { title: '健康档案', desc: '体检健康记录', mark: '健', type: 'health' },
      { title: '学生评价', desc: '成长表现反馈', mark: '评', type: 'evaluation' },
      { title: '校园活动', desc: '报名与详情', mark: '活', type: 'activity' },
      { title: '学校信息', desc: '学校介绍', mark: '校', type: 'school' },
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
        { title: '作业列表', desc: '查看全部作业', mark: '作', type: 'homework' },
        { title: '成绩报告', desc: '查看考试成绩', mark: '绩', type: 'grade' },
      ];
    }
    if (this.role === UserRole.TEACHER) {
      return [
        { title: '学生名单', desc: '班级成员', mark: '名', type: 'students' },
        { title: '考勤管理', desc: '学生出勤', mark: '勤', type: 'attendance' },
        { title: '成绩管理', desc: '成绩报告', mark: '绩', type: 'grade' },
        { title: '写评价', desc: '选择学生评价', mark: '评', type: 'students' },
      ];
    }
    if (this.role === UserRole.LEADER) {
      return [
        { title: '发布通知', desc: '创建通知公告', mark: '通', type: 'publish' },
        { title: '我的发布', desc: '查看发布记录', mark: '发', type: 'published' },
        { title: '组织架构', desc: '校园结构', mark: '组', type: 'org' },
      ];
    }
    return [{ title: '消息列表', desc: '进入会话', mark: '讯', type: 'chat' }];
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
