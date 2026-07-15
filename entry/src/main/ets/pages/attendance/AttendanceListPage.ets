import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { AttendanceService } from '../../services/AttendanceService';
import { AttendanceRecord, AttendanceStatus } from '../../models/AttendanceModel';
import { DateUtil } from '../../utils/DateUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';
import { FormDatePicker } from '../../components/form/FormDatePicker';

interface AttendanceListParams {
  studentId?: string;
}

@Entry
@Component
struct AttendanceListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State records: AttendanceRecord[] = [];
  @State loading: boolean = true;
  @State studentId: string = '';
  @State monthLabel: string = '';
  @State presentCount: number = 0;
  @State lateCount: number = 0;
  @State absentCount: number = 0;
  @State leaveCount: number = 0;
  @State showForm: boolean = false;
  @State submitting: boolean = false;
  @State formStudentId: string = '';
  @State formDate: number = 0;
  @State formCheckInTime: string = '';
  @State formStatus: AttendanceStatus = 'present';
  @State formRemark: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as AttendanceListParams;
    const id = (params && params.studentId) || this.userStore.getStudentId();
    this.studentId = id || '';
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;
    const res = await AttendanceService.getRecords(this.studentId || undefined);
    this.records = res.code === 0 && res.data ? res.data : [];
    this.computeSummary();
    this.loading = false;
  }

  computeSummary(): void {
    const records = this.records || [];
    this.presentCount = records.filter((r: AttendanceRecord) => r.status === 'present').length;
    this.lateCount = records.filter((r: AttendanceRecord) => r.status === 'late').length;
    this.absentCount = records.filter((r: AttendanceRecord) => r.status === 'absent').length;
    this.leaveCount = records.filter((r: AttendanceRecord) => r.status === 'leave').length;

    let latestDate = '';
    for (const r of records) {
      if (r.date > latestDate) {
        latestDate = r.date;
      }
    }
    if (latestDate) {
      const year = latestDate.substring(0, 4);
      const month = latestDate.substring(5, 7);
      this.monthLabel = `${year}年${month}月考勤统计`;
    } else {
      const now = new Date();
      this.monthLabel = `${now.getFullYear()}年${now.getMonth() + 1}月考勤统计`;
    }
  }

  build() {
    Column() {
      AppNavBar({ title: '学生考勤' }) {
        if (this.userStore.isTeacher()) {
          Button('+ 记录')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .height(32)
            .onClick(() => { this.showAttendanceForm(); })
        }
      }

      if (this.showForm) {
        this.AttendanceForm()
      }

      Column() {
        Text(this.monthLabel)
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
          .width('100%')
        Row() {
          this.StatItem('出勤', `${this.presentCount}`, Constants.COLOR_SUCCESS)
          this.StatItem('迟到', `${this.lateCount}`, Constants.COLOR_WARNING)
          this.StatItem('缺勤', `${this.absentCount}`, Constants.COLOR_DANGER)
          this.StatItem('请假', `${this.leaveCount}`, Constants.COLOR_INFO)
        }
        .width('100%')
        .margin({ top: Constants.SPACE_MD })
      }
      .width('100%')
      .padding(Constants.SPACE_LG)
      .backgroundColor(Constants.COLOR_WHITE)
      .borderRadius(Constants.CARD_RADIUS)

      if (this.loading) {
        LoadingView()
      } else if ((this.records || []).length === 0) {
        EmptyView({ message: '暂无考勤记录' })
      } else {
        List() {
          ForEach(this.records || [], (record: AttendanceRecord) => {
            ListItem() {
              Row() {
                Column() {
                  Text(record.date.substring(5, 10))
                    .fontSize(Constants.FONT_SM)
                    .fontColor(Constants.COLOR_TEXT_HINT)
                  Text(record.date.substring(8))
                    .fontSize(Constants.FONT_XL)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Constants.COLOR_TEXT_PRIMARY)
                }
                .width(56)

                Column() {
                  Row() {
                    Text(this.getStatusLabel(record.status))
                      .fontSize(Constants.FONT_LG)
                      .fontColor(this.getStatusColor(record.status))
                    if (!this.studentId && record.studentName) {
                      Text(`  ${record.studentName}`)
                        .fontSize(Constants.FONT_SM)
                        .fontColor(Constants.COLOR_TEXT_HINT)
                    }
                  }
                  .width('100%')

                  Text(`入校 ${record.checkInTime || '--:--'}  离校 ${record.checkOutTime || '--:--'}`)
                    .fontSize(Constants.FONT_SM)
                    .fontColor(Constants.COLOR_TEXT_HINT)
                    .margin({ top: 2 })

                  if (record.remark) {
                    Text(`备注：${record.remark}`)
                      .fontSize(Constants.FONT_SM)
                      .fontColor(Constants.COLOR_TEXT_SECONDARY)
                      .margin({ top: 2 })
                  }
                }
                .margin({ left: Constants.SPACE_MD })
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding(Constants.SPACE_MD)
              .backgroundColor(Constants.COLOR_WHITE)
              .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
            }
          }, (record: AttendanceRecord) => record.id)
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
  StatItem(label: string, value: string, color: string) {
    Column() {
      Text(value).fontSize(Constants.FONT_XXL).fontWeight(FontWeight.Bold).fontColor(color)
      Text(label).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_HINT).margin({ top: 2 })
    }
    .layoutWeight(1)
  }

  @Builder
  StatusChip(value: AttendanceStatus, label: string) {
    Text(label)
      .fontSize(Constants.FONT_MD)
      .fontColor(this.formStatus === value ? Constants.COLOR_WHITE : Constants.COLOR_TEXT_SECONDARY)
      .fontWeight(this.formStatus === value ? FontWeight.Bold : FontWeight.Normal)
      .backgroundColor(this.formStatus === value ? Constants.COLOR_PRIMARY : Constants.COLOR_SURFACE)
      .border({ width: 1, color: this.formStatus === value ? Constants.COLOR_PRIMARY : Constants.COLOR_BORDER })
      .borderRadius(Constants.BUTTON_RADIUS)
      .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD, top: 6, bottom: 6 })
      .layoutWeight(1)
      .textAlign(TextAlign.Center)
      .onClick(() => { this.formStatus = value; })
  }

  @Builder
  AttendanceForm() {
    Column() {
      Text('录入考勤')
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
        .onChange((v: string) => { this.formStudentId = this.normalizeStudentId(v); })

      Text('日期')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      FormDatePicker({ timestamp: $formDate, placeholder: '选择日期', allowPast: true, allowFuture: false })

      Text('入校时间')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '例如 08:00', text: this.formCheckInTime })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formCheckInTime = v; })

      Text('考勤状态')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      Row() {
        this.StatusChip('present', '出勤')
        this.StatusChip('late', '迟到')
        this.StatusChip('absent', '缺勤')
        this.StatusChip('leave', '请假')
      }
      .width('100%')
      .margin({ top: 4, bottom: Constants.SPACE_SM })

      Text('备注')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextArea({ placeholder: '请输入备注', text: this.formRemark })
        .width('100%')
        .height(72)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding(Constants.SPACE_MD)
        .margin({ top: 4 })
        .onChange((v: string) => { this.formRemark = v; })

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
        Button(this.submitting ? '保存中...' : '保存')
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .enabled(!this.submitting)
          .onClick(() => { this.handleSubmit(); })
      }
      .width('100%')
      .margin({ top: Constants.SPACE_MD })
    }
    .width('100%')
    .padding(Constants.SPACE_LG)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
  }

  showAttendanceForm(): void {
    this.formStudentId = this.studentId;
    this.formDate = Date.now();
    this.formCheckInTime = '08:00';
    this.formStatus = 'present';
    this.formRemark = '';
    this.showForm = true;
  }

  private normalizeStudentId(value: string): string {
    let result = '';
    for (let i = 0; i < value.length && result.length < 18; i++) {
      const ch = value.charAt(i);
      if (ch >= '0' && ch <= '9') {
        result += ch;
      }
    }
    return result;
  }

  private isClockValue(value: string): boolean {
    if (!value) {
      return true;
    }
    const parts = value.split(':');
    if (parts.length !== 2) {
      return false;
    }
    const hour = Number(parts[0]);
    const minute = Number(parts[1]);
    return !Number.isNaN(hour) && !Number.isNaN(minute) && hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
  }

  async handleSubmit(): Promise<void> {
    if (!this.formStudentId || this.formDate <= 0) {
      promptAction.openToast({ message: '请填写学生ID和日期' });
      return;
    }
    if (!this.isClockValue(this.formCheckInTime)) {
      promptAction.openToast({ message: '入校时间格式应为 HH:mm' });
      return;
    }
    const record: AttendanceRecord = {
      id: `att_${Date.now()}`,
      studentId: this.formStudentId,
      studentName: '',
      studentAvatar: '',
      classId: '',
      className: '',
      date: DateUtil.formatDate(this.formDate),
      dayOfWeek: '',
      checkInTime: this.formCheckInTime,
      status: this.formStatus,
      method: 'manual',
      remark: this.formRemark,
    };
    this.submitting = true;
    const res = await AttendanceService.create(record);
    this.submitting = false;
    if (res.code === 0) {
      promptAction.openToast({ message: '录入成功' });
      this.showForm = false;
      await this.loadData();
    } else {
      promptAction.openToast({ message: res.message || '录入失败' });
    }
  }

  getStatusLabel(status: string): string {
    switch (status) {
      case 'present': return '正常到校';
      case 'late': return '迟到';
      case 'absent': return '缺勤';
      case 'leave': return '请假';
      case 'early': return '早退';
      default: return status;
    }
  }

  getStatusColor(status: string): string {
    switch (status) {
      case 'present': return Constants.COLOR_SUCCESS;
      case 'late': return Constants.COLOR_WARNING;
      case 'absent': return Constants.COLOR_DANGER;
      case 'leave': return Constants.COLOR_INFO;
      case 'early': return Constants.COLOR_WARNING;
      default: return Constants.COLOR_TEXT_PRIMARY;
    }
  }
}
