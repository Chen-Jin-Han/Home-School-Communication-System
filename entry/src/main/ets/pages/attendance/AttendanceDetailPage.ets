import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { AttendanceService } from '../../services/AttendanceService';
import { AttendanceRecord } from '../../models/AttendanceModel';
import { DateUtil } from '../../utils/DateUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';

interface AttendanceDetailParams {
  date: string;
  studentId: string;
}

@Entry
@Component
struct AttendanceDetailPage {
  @State record: AttendanceRecord | null = null;
  @State loading: boolean = true;
  private date: string = '';
  private studentId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as AttendanceDetailParams;
    if (!params || !params.date || !params.studentId) {
      router.back();
      this.loading = false;
      return;
    }
    this.date = params.date;
    this.studentId = params.studentId;
    const res = await AttendanceService.getRecords(this.studentId);
    const records = res.code === 0 && res.data ? res.data : [];
    this.record = records.find(r => r.date === this.date) || null;
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '考勤详情' })
      if (this.loading) {
        LoadingView()
      } else if (this.record) {
        Column() {
          Text(this.record.date).fontSize(Constants.FONT_XXL).fontWeight(FontWeight.Bold).width('100%').padding(Constants.SPACE_LG)
          Column() {
            this.DetailRow('学生', this.record.studentName)
            this.DetailRow('班级', this.record.className)
            this.DetailRow('状态', this.getStatusLabel())
            if (this.record.checkInTime) this.DetailRow('入校时间', this.record.checkInTime)
            if (this.record.checkOutTime) this.DetailRow('离校时间', this.record.checkOutTime)
            this.DetailRow('考勤方式', this.record.method === 'card' ? '刷卡' : this.record.method === 'face' ? '人脸识别' : '手动录入')
            if (this.record.remark) this.DetailRow('备注', this.record.remark)
          }
          .width('100%')
          .padding(Constants.SPACE_LG)
          .backgroundColor(Constants.COLOR_WHITE)
          .margin({ top: Constants.SPACE_MD })
        }
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  getStatusLabel(): string {
    const status = this.record?.status || '';
    switch (status) {
      case 'present': return '正常到校';
      case 'late': return '迟到';
      case 'absent': return '缺勤';
      case 'leave': return '请假';
      case 'early': return '早退';
      default: return '';
    }
  }

  @Builder
  DetailRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_HINT).width(80)
      Text(value).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_PRIMARY).layoutWeight(1)
    }
    .width('100%')
    .padding({ top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
  }
}
