import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { ActivityService } from '../../services/ActivityService';
import { Activity } from '../../models/ActivityModel';
import { ActivityCard } from '../../components/card/ActivityCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';
import { FormDatePicker } from '../../components/form/FormDatePicker';

@Entry
@Component
struct ActivityListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State activities: Activity[] = [];
  @State loading: boolean = true;
  @State statusFilter: string = 'upcoming';
  @State showForm: boolean = false;
  @State publishing: boolean = false;
  @State formTitle: string = '';
  @State formDescription: string = '';
  @State formLocation: string = '';
  @State formStartTime: number = 0;
  @State formEndTime: number = 0;
  @State formStartClock: string = '';
  @State formEndClock: string = '';
  @State formMaxParticipants: string = '';

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;
    const res = await ActivityService.getList(this.statusFilter);
    this.activities = res.code === 0 && res.data ? (res.data.list || []) : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '校园活动' }) {
        if (this.userStore.isTeacher()) {
          Button('+ 发布')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .height(32)
            .onClick(() => { this.showPublishForm(); })
        }
      }

      if (this.showForm) {
        this.PublishForm()
      }

      Row() {
        this.FilterTab('即将开始', 'upcoming')
        this.FilterTab('进行中', 'ongoing')
        this.FilterTab('已结束', 'ended')
      }
      .width('100%')
      .padding({ left: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })

      if (this.loading) {
        LoadingView()
      } else if ((this.activities || []).length === 0) {
        EmptyView({ message: '暂无可显示的活动' })
      } else {
        List() {
          ForEach(this.activities || [], (act: Activity) => {
            ListItem() {
              ActivityCard({ activity: act, onTap: () => { RouterUtil.toActivityDetail(act.id); } })
            }
          }, (act: Activity) => act.id)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  FilterTab(label: string, value: string) {
    Text(label)
      .fontSize(Constants.FONT_MD)
      .fontColor(this.statusFilter === value ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT)
      .fontWeight(this.statusFilter === value ? FontWeight.Bold : FontWeight.Normal)
      .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD, top: 6, bottom: 6 })
      .onClick(() => {
        this.statusFilter = value;
        this.loadData();
      })
  }

  @Builder
  PublishForm() {
    Column() {
      Text('发布活动')
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: Constants.SPACE_SM })

      Text('活动标题')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextInput({ placeholder: '请输入标题', text: this.formTitle })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formTitle = v; })

      Text('活动描述')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextArea({ placeholder: '请输入活动描述', text: this.formDescription })
        .width('100%')
        .height(80)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding(Constants.SPACE_MD)
        .margin({ top: 4 })
        .onChange((v: string) => { this.formDescription = v; })

      Text('活动地点')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '请输入地点', text: this.formLocation })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formLocation = v; })

      Text('开始日期')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      FormDatePicker({ timestamp: $formStartTime, placeholder: '选择开始日期' })

      Text('开始时间')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '例如 09:00', text: this.formStartClock })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formStartClock = v; })

      Text('结束日期')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      FormDatePicker({ timestamp: $formEndTime, placeholder: '选择结束日期' })

      Text('结束时间')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '例如 17:00', text: this.formEndClock })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formEndClock = v; })

      Text('最大参与人数')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '请输入大于 0 的人数', text: this.formMaxParticipants })
        .width('100%')
        .height(40)
        .type(InputType.Number)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4 })
        .onChange((v: string) => { this.formMaxParticipants = v; })

      Row() {
        Button('取消')
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_TEXT_SECONDARY)
          .backgroundColor(Constants.COLOR_BG)
          .borderRadius(Constants.BUTTON_RADIUS)
          .margin({ right: Constants.SPACE_SM })
          .onClick(() => { this.showForm = false; })
        Button(this.publishing ? '发布中...' : '发布')
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .enabled(!this.publishing)
          .onClick(() => { this.handlePublish(); })
      }
      .width('100%')
      .margin({ top: Constants.SPACE_MD })
    }
    .width('100%')
    .padding(Constants.SPACE_LG)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM })
  }

  showPublishForm(): void {
    this.formTitle = '';
    this.formDescription = '';
    this.formLocation = '';
    this.formStartTime = Date.now() + 86400000;
    this.formEndTime = Date.now() + 86400000 * 2;
    this.formStartClock = '09:00';
    this.formEndClock = '17:00';
    this.formMaxParticipants = '';
    this.showForm = true;
  }

  private isClockValue(value: string): boolean {
    const parts = value.split(':');
    if (parts.length !== 2) {
      return false;
    }
    const hour = Number(parts[0]);
    const minute = Number(parts[1]);
    return !Number.isNaN(hour) && !Number.isNaN(minute) && hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
  }

  private combineDateAndClock(dateValue: number, clock: string): number {
    const parts = clock.split(':');
    const hour = Number(parts[0]);
    const minute = Number(parts[1]);
    const date = new Date(dateValue);
    date.setHours(hour, minute, 0, 0);
    return date.getTime();
  }

  async handlePublish(): Promise<void> {
    if (!this.formTitle || !this.formDescription) {
      promptAction.openToast({ message: '请填写标题和描述' });
      return;
    }
    if (!this.isClockValue(this.formStartClock) || !this.isClockValue(this.formEndClock)) {
      promptAction.openToast({ message: '活动时间格式应为 HH:mm' });
      return;
    }
    const maxNum = Number(this.formMaxParticipants);
    if (!this.formMaxParticipants || Number.isNaN(maxNum) || maxNum <= 0) {
      promptAction.openToast({ message: '最大参与人数必须大于 0' });
      return;
    }
    const startTime = this.combineDateAndClock(this.formStartTime, this.formStartClock);
    const endTime = this.combineDateAndClock(this.formEndTime, this.formEndClock);
    if (startTime >= endTime) {
      promptAction.openToast({ message: '开始时间必须早于结束时间' });
      return;
    }
    const store = UserStore.getInstance();
    const now = Date.now();
    const activity: Activity = {
      id: `act_${now}`,
      title: this.formTitle,
      description: this.formDescription,
      coverImage: '',
      organizerId: store.currentUser?.id || '',
      organizerName: store.currentUser?.name || '',
      location: this.formLocation,
      startTime: startTime,
      endTime: endTime,
      participantCount: 0,
      maxParticipants: maxNum,
      photos: [],
      status: 'upcoming',
      createdAt: now,
    };
    this.publishing = true;
    const res = await ActivityService.create(activity);
    this.publishing = false;
    if (res.code === 0) {
      promptAction.openToast({ message: '发布成功' });
      this.showForm = false;
      await this.loadData();
    } else {
      promptAction.openToast({ message: res.message || '发布失败' });
    }
  }
}
