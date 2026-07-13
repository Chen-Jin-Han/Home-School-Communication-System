import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { GradeService } from '../../services/GradeService';
import { GradeReport, SubjectGrade } from '../../models/GradeModel';
import { DateUtil } from '../../utils/DateUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';

interface GradeDetailParams {
  reportId: string;
}

@Entry
@Component
struct GradeDetailPage {
  @State report: GradeReport | null = null;
  @State loading: boolean = true;
  private reportId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as GradeDetailParams;
    this.reportId = params.reportId;
    const res = await GradeService.getDetail(this.reportId);
    this.report = res.data || null;
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '成绩详情' })
      if (this.loading) {
        LoadingView()
      } else if (this.report) {
        Scroll() {
          Column() {
            // Header
            Text(this.report.examName)
              .fontSize(Constants.FONT_XXL)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .width('100%')

            Row() {
              Text(`总分: ${this.report.totalScore}/${this.report.totalFullScore}`)
                .fontSize(Constants.FONT_XL)
                .fontWeight(FontWeight.Bold)
                .fontColor(Constants.COLOR_PRIMARY)
              Blank()
              Text(DateUtil.formatDate(this.report.examDate))
                .fontSize(Constants.FONT_SM)
                .fontColor(Constants.COLOR_TEXT_HINT)
            }
            .width('100%')
            .margin({ top: Constants.SPACE_SM })

            Row() {
              Text(`班级第${this.report.classRank}名 (共${this.report.classSize}人)`)
                .fontSize(Constants.FONT_MD)
                .fontColor(Constants.COLOR_TEXT_SECONDARY)
              Text(`  年级第${this.report.gradeRank}名 (共${this.report.gradeSize}人)`)
                .fontSize(Constants.FONT_MD)
                .fontColor(Constants.COLOR_TEXT_SECONDARY)
            }
            .width('100%')
            .margin({ top: 4 })

            Divider().margin({ top: Constants.SPACE_LG, bottom: Constants.SPACE_MD })

            // Subject breakdown
            Text('各科成绩').fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).width('100%').margin({ bottom: Constants.SPACE_MD })

            ForEach(this.report.subjects || [], (sg: SubjectGrade) => {
              this.SubjectRow(sg)
            })

            if (this.report.teacherComment) {
              Blank().height(Constants.SPACE_XL)
              Text('教师评语').fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).width('100%')
              Text(this.report.teacherComment)
                .fontSize(Constants.FONT_MD)
                .fontColor(Constants.COLOR_TEXT_SECONDARY)
                .lineHeight(24)
                .width('100%')
                .padding(Constants.SPACE_MD)
                .backgroundColor(Constants.COLOR_DIVIDER)
                .borderRadius(Constants.CARD_RADIUS)
                .margin({ top: Constants.SPACE_SM })
            }
          }
          .width('100%')
          .padding(Constants.SPACE_LG)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_WHITE)
  }

  @Builder
  SubjectRow(sg: SubjectGrade) {
    Row() {
      Text(sg.subject).fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).fontColor(Constants.COLOR_TEXT_PRIMARY).width(60)
      Text(`${sg.score}/${sg.fullScore}`).fontSize(Constants.FONT_XL).fontWeight(FontWeight.Bold).fontColor(Constants.COLOR_PRIMARY).width(80)
      Column() {
        Text(`班级平均${sg.classAverage}  年级平均${sg.gradeAverage}`).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_HINT)
        Text(`班级第${sg.classRank}名  年级第${sg.gradeRank}名`).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_HINT).margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      Text(sg.trend === 'up' ? '↑' : sg.trend === 'down' ? '↓' : '→')
        .fontSize(Constants.FONT_XL)
        .fontColor(sg.trend === 'up' ? Constants.COLOR_SUCCESS : sg.trend === 'down' ? Constants.COLOR_DANGER : Constants.COLOR_TEXT_HINT)
    }
    .width('100%')
    .padding({ top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
  }
}
