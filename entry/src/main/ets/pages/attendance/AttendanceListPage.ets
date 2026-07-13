import { Constants } from '../../utils/Constants';
import { AttendanceService } from '../../services/AttendanceService';
import { AttendanceRecord } from '../../models/AttendanceModel';
import { DateUtil } from '../../utils/DateUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

@Entry
@Component
struct AttendanceListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State records: AttendanceRecord[] = [];
  @State loading: boolean = true;

  async aboutToAppear(): Promise<void> {
    const studentId = this.userStore.getStudentId();
    if (studentId) {
      const res = await AttendanceService.getRecords(studentId);
      this.records = res.code === 0 && res.data ? res.data : [];
    }
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '学生考勤' })

      // Summary card
      Column() {
        Text('2026年7月考勤统计').fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).fontColor(Constants.COLOR_TEXT_PRIMARY).width('100%')
        Row() {
          this.StatItem('出勤', '2', Constants.COLOR_SUCCESS)
          this.StatItem('迟到', '1', Constants.COLOR_WARNING)
          this.StatItem('缺勤', '1', Constants.COLOR_DANGER)
          this.StatItem('请假', '1', Constants.COLOR_INFO)
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
                  Text(record.dayOfWeek).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_HINT)
                  Text(record.date.substring(8)).fontSize(Constants.FONT_XL).fontWeight(FontWeight.Bold).fontColor(Constants.COLOR_TEXT_PRIMARY)
                }
                .width(50)

                Column() {
                  Text(this.getStatusLabel(record.status)).fontSize(Constants.FONT_LG).fontColor(this.getStatusColor(record.status))
                  if (record.checkInTime) {
                    Text(`入校 ${record.checkInTime}  离校 ${record.checkOutTime || '--:--'}`)
                      .fontSize(Constants.FONT_SM)
                      .fontColor(Constants.COLOR_TEXT_HINT)
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
          })
        }
        .layoutWeight(1)
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
