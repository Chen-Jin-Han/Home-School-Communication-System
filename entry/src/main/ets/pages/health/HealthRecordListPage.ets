import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { HealthService } from '../../services/HealthService';
import { HealthRecord } from '../../models/HealthModel';
import { HealthCard } from '../../components/card/HealthCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

type HealthStatus = 'healthy' | 'attention' | 'concern';

interface HealthRecordListParams {
  studentId?: string;
}

@Entry
@Component
struct HealthRecordListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State records: HealthRecord[] = [];
  @State loading: boolean = true;
  @State showForm: boolean = false;
  @State saving: boolean = false;
  @State formStudentId: string = '';
  @State formHeight: string = '';
  @State formWeight: string = '';
  @State formTemperature: string = '';
  @State formHeartRate: string = '';
  @State formHealthStatus: HealthStatus = 'healthy';
  private studentId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as HealthRecordListParams;
    this.studentId = (params && params.studentId) || this.userStore.getStudentId() || '';
    await this.loadRecords();
  }

  async loadRecords(): Promise<void> {
    this.loading = true;
    if (!this.studentId && !this.userStore.isTeacher() && !this.userStore.isLeader()) {
      this.records = [];
      this.loading = false;
      return;
    }
    const res = await HealthService.getRecords(this.studentId || undefined);
    this.records = res.code === 0 && res.data ? res.data : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '健康档案' }) {
        if (this.userStore.isTeacher()) {
          Button('+ 新增')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .height(32)
            .onClick(() => { this.showAddForm(); })
        }
      }

      if (this.showForm) {
        this.AddForm()
      }

      if (this.loading) {
        LoadingView()
      } else if ((this.records || []).length === 0) {
        EmptyView({ message: '暂无健康记录' })
      } else {
        List() {
          ForEach(this.records || [], (record: HealthRecord) => {
            ListItem() {
              HealthCard({ record: record, onTap: () => { RouterUtil.toHealthDetail(record.id); } })
            }
          }, (record: HealthRecord) => record.id)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  AddForm() {
    Column() {
      Text('新增健康记录')
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: Constants.SPACE_SM })

      Text('学生ID')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextInput({ placeholder: '请输入学生ID', text: this.formStudentId })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formStudentId = v; })

      Row() {
        Column() {
          Text('身高(cm)')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_SECONDARY)
            .width('100%')
          TextInput({ placeholder: '身高', text: this.formHeight })
            .width('100%')
            .height(40)
            .type(InputType.Number)
            .fontSize(Constants.FONT_MD)
            .backgroundColor(Constants.COLOR_SURFACE)
            .borderRadius(Constants.BUTTON_RADIUS)
            .border({ width: 0.5, color: Constants.COLOR_BORDER })
            .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
            .margin({ top: 4 })
            .onChange((v: string) => { this.formHeight = v; })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('体重(kg)')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_SECONDARY)
            .width('100%')
          TextInput({ placeholder: '体重', text: this.formWeight })
            .width('100%')
            .height(40)
            .type(InputType.Number)
            .fontSize(Constants.FONT_MD)
            .backgroundColor(Constants.COLOR_SURFACE)
            .borderRadius(Constants.BUTTON_RADIUS)
            .border({ width: 0.5, color: Constants.COLOR_BORDER })
            .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
            .margin({ top: 4 })
            .onChange((v: string) => { this.formWeight = v; })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: Constants.SPACE_SM })
      }
      .width('100%')

      Row() {
        Column() {
          Text('体温(℃)')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_SECONDARY)
            .width('100%')
          TextInput({ placeholder: '体温', text: this.formTemperature })
            .width('100%')
            .height(40)
            .type(InputType.Number)
            .fontSize(Constants.FONT_MD)
            .backgroundColor(Constants.COLOR_SURFACE)
            .borderRadius(Constants.BUTTON_RADIUS)
            .border({ width: 0.5, color: Constants.COLOR_BORDER })
            .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
            .margin({ top: 4 })
            .onChange((v: string) => { this.formTemperature = v; })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('心率(bpm)')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_SECONDARY)
            .width('100%')
          TextInput({ placeholder: '心率', text: this.formHeartRate })
            .width('100%')
            .height(40)
            .type(InputType.Number)
            .fontSize(Constants.FONT_MD)
            .backgroundColor(Constants.COLOR_SURFACE)
            .borderRadius(Constants.BUTTON_RADIUS)
            .border({ width: 0.5, color: Constants.COLOR_BORDER })
            .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
            .margin({ top: 4 })
            .onChange((v: string) => { this.formHeartRate = v; })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: Constants.SPACE_SM })
      }
      .width('100%')
      .margin({ top: Constants.SPACE_SM })

      Text('健康状况')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      Row() {
        Text('健康')
          .fontSize(Constants.FONT_SM)
          .fontColor(this.formHealthStatus === 'healthy' ? Constants.COLOR_WHITE : Constants.COLOR_PRIMARY)
          .backgroundColor(this.formHealthStatus === 'healthy' ? Constants.COLOR_PRIMARY : Constants.COLOR_PRIMARY_SOFT)
          .borderRadius(14)
          .height(30)
          .padding({ left: 12, right: 12 })
          .margin({ right: 8 })
          .onClick(() => { this.formHealthStatus = 'healthy'; })
        Text('关注')
          .fontSize(Constants.FONT_SM)
          .fontColor(this.formHealthStatus === 'attention' ? Constants.COLOR_WHITE : Constants.COLOR_PRIMARY)
          .backgroundColor(this.formHealthStatus === 'attention' ? Constants.COLOR_PRIMARY : Constants.COLOR_PRIMARY_SOFT)
          .borderRadius(14)
          .height(30)
          .padding({ left: 12, right: 12 })
          .margin({ right: 8 })
          .onClick(() => { this.formHealthStatus = 'attention'; })
        Text('异常')
          .fontSize(Constants.FONT_SM)
          .fontColor(this.formHealthStatus === 'concern' ? Constants.COLOR_WHITE : Constants.COLOR_PRIMARY)
          .backgroundColor(this.formHealthStatus === 'concern' ? Constants.COLOR_PRIMARY : Constants.COLOR_PRIMARY_SOFT)
          .borderRadius(14)
          .height(30)
          .padding({ left: 12, right: 12 })
          .onClick(() => { this.formHealthStatus = 'concern'; })
      }
      .width('100%')
      .margin({ top: 4 })

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
        Button(this.saving ? '保存中...' : '保存')
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .enabled(!this.saving)
          .onClick(() => { this.handleSave(); })
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

  showAddForm(): void {
    this.formStudentId = this.studentId;
    this.formHeight = '';
    this.formWeight = '';
    this.formTemperature = '';
    this.formHeartRate = '';
    this.formHealthStatus = 'healthy';
    this.showForm = true;
  }

  async handleSave(): Promise<void> {
    if (!this.formStudentId) {
      promptAction.openToast({ message: '请输入学生ID' });
      return;
    }
    const heightNum = Number(this.formHeight);
    const weightNum = Number(this.formWeight);
    const tempNum = Number(this.formTemperature);
    const heartNum = Number(this.formHeartRate);
    const now = Date.now();
    const bmiVal = heightNum > 0 ? weightNum / ((heightNum / 100) * (heightNum / 100)) : 0;
    const record: HealthRecord = {
      id: `hr_${now}`,
      studentId: this.formStudentId,
      studentName: '',
      className: '',
      recordDate: now,
      height: heightNum,
      weight: weightNum,
      bmi: Math.round(bmiVal * 10) / 10,
      visionLeft: 0,
      visionRight: 0,
      temperature: tempNum,
      bloodPressure: '',
      heartRate: heartNum,
      vaccinations: [],
      medicalHistory: '',
      allergies: '',
      healthStatus: this.formHealthStatus,
      updatedAt: now,
    };
    this.saving = true;
    const res = await HealthService.create(record);
    this.saving = false;
    if (res.code === 0) {
      promptAction.openToast({ message: '保存成功' });
      this.showForm = false;
      this.studentId = this.formStudentId;
      await this.loadRecords();
    } else {
      promptAction.openToast({ message: res.message || '保存失败' });
    }
  }
}
