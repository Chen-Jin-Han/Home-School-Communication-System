import { Homework } from '../../models/HomeworkModel';
import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';

@Component
export struct HomeworkCard {
  @Prop homework: Homework;
  onTap?: () => void;

  build() {
    Column() {
      Row() {
        Text(this.homework.subject)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_WHITE)
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .backgroundColor(this.getSubjectColor())
          .borderRadius(4)
        Blank()
        if (this.homework.status === 'expired') {
          Text('已截止')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor(Constants.COLOR_DIVIDER)
            .borderRadius(4)
        } else {
          Text(`截止 ${DateUtil.formatDate(this.homework.dueDate)}`)
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_WARNING)
        }
      }
      .width('100%')

      Text(this.homework.title)
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: Constants.SPACE_SM })
        .width('100%')

      Text(this.homework.content)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: Constants.SPACE_XS })
        .width('100%')

      Row() {
        Text(`提交 ${this.homework.submissionCount}/${this.homework.totalStudents}`)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
        Blank()
        Text(this.homework.teacherName)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
      }
      .width('100%')
      .margin({ top: Constants.SPACE_SM })
    }
    .padding(Constants.SPACE_MD)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
    .onClick(() => {
      if (this.onTap) {
        this.onTap();
      }
    })
  }

  getSubjectColor(): string {
    switch (this.homework.subject) {
      case '语文': return '#FF6B6B';
      case '数学': return '#4ECDC4';
      case '英语': return '#45B7D1';
      case '科学': return '#96CEB4';
      default: return Constants.COLOR_PRIMARY;
    }
  }
}
