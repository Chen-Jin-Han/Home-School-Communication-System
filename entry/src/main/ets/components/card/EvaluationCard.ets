import { Evaluation } from '../../models/EvaluationModel';
import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';

@Component
export struct EvaluationCard {
  @Prop evaluation: Evaluation;
  onTap?: () => void;

  build() {
    Column() {
      Row() {
        Text(this.evaluation.teacherName)
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
        Blank()
        Text(this.evaluation.periodLabel)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
      }
      .width('100%')

      Row() {
        ForEach(Array.from({ length: 5 }), (_: undefined, i: number) => {
          Text(i < this.evaluation.rating ? '★' : '☆')
            .fontSize(Constants.FONT_LG)
            .fontColor(i < this.evaluation.rating ? '#FAAD14' : Constants.COLOR_BORDER)
        })
      }
      .margin({ top: Constants.SPACE_SM })

      Text(this.evaluation.content)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: Constants.SPACE_SM })
        .width('100%')

      if ((this.evaluation.tags || []).length > 0) {
        Row() {
          ForEach(this.evaluation.tags || [], (tag: string) => {
            Text(tag)
              .fontSize(Constants.FONT_SM)
              .fontColor(Constants.COLOR_PRIMARY)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor('#E6F7FF')
              .borderRadius(4)
              .margin({ right: Constants.SPACE_SM })
          })
        }
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      }
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
