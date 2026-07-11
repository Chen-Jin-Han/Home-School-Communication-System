import { AttendanceRecord } from '../../models/AttendanceModel';
import { Constants } from '../../utils/Constants';

@Component
export struct AttendanceCard {
  @Prop record: AttendanceRecord;
  @Prop studentName: string = '';
  onTap?: () => void;

  build() {
    Column() {
      Row() {
        Text('今日考勤')
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
        Blank()
        Text(this.getStatusLabel())
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getStatusColor())
      }
      .width('100%')

      if (this.studentName) {
        Text(`学生: ${this.studentName}`)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_TEXT_SECONDARY)
          .margin({ top: Constants.SPACE_SM })
      }

      Divider()
        .margin({ top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })

      Row() {
        Column() {
          Text('入校时间')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
          Text(this.record.checkInTime || '--:--')
            .fontSize(Constants.FONT_XL)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text('离校时间')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
          Text(this.record.checkOutTime || '--:--')
            .fontSize(Constants.FONT_XL)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text('考勤方式')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
          Text(this.getMethodLabel())
            .fontSize(Constants.FONT_XL)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .padding(Constants.SPACE_LG)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
    .onClick(() => {
      if (this.onTap) {
        this.onTap();
      }
    })
  }

  getStatusLabel(): string {
    switch (this.record.status) {
      case 'present': return '已到校';
      case 'late': return '迟到';
      case 'absent': return '未到校';
      case 'leave': return '请假';
      case 'early': return '早退';
    }
  }

  getStatusColor(): string {
    switch (this.record.status) {
      case 'present': return Constants.COLOR_SUCCESS;
      case 'late': return Constants.COLOR_WARNING;
      case 'absent': return Constants.COLOR_DANGER;
      case 'leave': return Constants.COLOR_INFO;
      case 'early': return Constants.COLOR_WARNING;
    }
  }

  getMethodLabel(): string {
    switch (this.record.method) {
      case 'card': return '刷卡';
      case 'face': return '人脸';
      case 'manual': return '手动';
    }
  }
}
