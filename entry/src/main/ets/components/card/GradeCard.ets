import { GradeReport, SubjectGrade } from '../../models/GradeModel';
import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';

@Component
export struct GradeCard {
  @Prop report: GradeReport;
  onTap?: () => void;

  build() {
    Column() {
      Row() {
        Text(this.report.examName)
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
        Blank()
        Text(`${this.report.totalScore}/${this.report.totalFullScore}`)
          .fontSize(Constants.FONT_XXL)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_PRIMARY)
      }
      .width('100%')

      Row() {
        Text(DateUtil.formatDate(this.report.examDate))
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
        Blank()
        Text(`班级第${this.report.classRank}名 (${this.report.classSize}人)`)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_SECONDARY)
      }
      .width('100%')
      .margin({ top: Constants.SPACE_SM })

      Divider()
        .margin({ top: Constants.SPACE_MD, bottom: Constants.SPACE_SM })

      Row() {
        ForEach(this.report.subjects.slice(0, 4), (sg: SubjectGrade) => {
          Column() {
            Text(sg.subject)
              .fontSize(Constants.FONT_SM)
              .fontColor(Constants.COLOR_TEXT_HINT)
            Text(`${sg.score}`)
              .fontSize(Constants.FONT_LG)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .margin({ top: 2 })
          }
          .layoutWeight(1)
        })
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
}
