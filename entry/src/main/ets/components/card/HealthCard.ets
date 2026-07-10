import { HealthRecord } from '../../models/HealthModel';
import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';

@Component
export struct HealthCard {
  @Prop record: HealthRecord;
  onTap?: () => void;

  build() {
    Column() {
      Row() {
        Text('健康档案')
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
        Blank()
        Text(DateUtil.formatDate(this.record.recordDate))
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
      }
      .width('100%')

      Row() {
        Column() {
          Text('身高')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
          Text(`${this.record.height}cm`)
            .fontSize(Constants.FONT_LG)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .margin({ top: 2 })
        }
        .layoutWeight(1)

        Column() {
          Text('体重')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
          Text(`${this.record.weight}kg`)
            .fontSize(Constants.FONT_LG)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .margin({ top: 2 })
        }
        .layoutWeight(1)

        Column() {
          Text('BMI')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
          Text(this.record.bmi.toFixed(1))
            .fontSize(Constants.FONT_LG)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getHealthColor())
            .margin({ top: 2 })
        }
        .layoutWeight(1)

        Column() {
          Text('视力')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
          Text(`${this.record.visionLeft}/${this.record.visionRight}`)
            .fontSize(Constants.FONT_LG)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .margin({ top: 2 })
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ top: Constants.SPACE_MD })
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

  getHealthColor(): string {
    switch (this.record.healthStatus) {
      case 'healthy': return Constants.COLOR_SUCCESS;
      case 'attention': return Constants.COLOR_WARNING;
      case 'concern': return Constants.COLOR_DANGER;
    }
  }
}
