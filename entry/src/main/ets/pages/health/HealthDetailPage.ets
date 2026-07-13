import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { HealthService } from '../../services/HealthService';
import { HealthRecord, Vaccination } from '../../models/HealthModel';
import { DateUtil } from '../../utils/DateUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { ElementIcon } from '../../components/common/ElementIcon';

interface HealthDetailParams {
  recordId: string;
}

@Entry
@Component
struct HealthDetailPage {
  @State record: HealthRecord | null = null;
  @State loading: boolean = true;
  private recordId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as HealthDetailParams;
    this.recordId = params.recordId;
    const res = await HealthService.getDetail(this.recordId);
    this.record = res.data || null;
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '健康档案详情' })
      if (this.loading) {
        LoadingView()
      } else if (this.record) {
        Scroll() {
          Column() {
            Text(DateUtil.formatDate(this.record.recordDate)).fontSize(Constants.FONT_XXL).fontWeight(FontWeight.Bold).width('100%')
            Text(`${this.record.studentName} · ${this.record.className}`).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_HINT).margin({ top: 4 })

            Divider().margin({ top: Constants.SPACE_LG, bottom: Constants.SPACE_MD })

            // Basic measurements
            Text('基础指标').fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).width('100%').margin({ bottom: Constants.SPACE_MD })
            Row() {
              this.MetricCol('身高', `${this.record.height} cm`)
              this.MetricCol('体重', `${this.record.weight} kg`)
              this.MetricCol('BMI', this.record.bmi.toFixed(1))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Row() {
              this.MetricCol('左眼视力', `${this.record.visionLeft}`)
              this.MetricCol('右眼视力', `${this.record.visionRight}`)
              this.MetricCol('体温', `${this.record.temperature}°C`)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: Constants.SPACE_MD })

            Row() {
              this.MetricCol('血压', this.record.bloodPressure)
              this.MetricCol('心率', `${this.record.heartRate} bpm`)
              Column().layoutWeight(1)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: Constants.SPACE_MD })

            // Vaccinations
            if ((this.record.vaccinations || []).length > 0) {
              Text('疫苗接种').fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).width('100%').margin({ top: Constants.SPACE_XL, bottom: Constants.SPACE_SM })
              ForEach(this.record.vaccinations || [], (v: Vaccination) => {
                Row() {
                  ElementIcon({ name: 'Health', size: 16, color: Constants.COLOR_SUCCESS })
                  Column() {
                    Text(v.name || '疫苗记录').fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_PRIMARY)
                    Text(`${v.date ? DateUtil.formatDate(v.date) : '--'} · ${v.location || '未记录地点'}`).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_HINT).margin({ top: 2 })
                  }
                  .margin({ left: Constants.SPACE_SM })
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)
                }
                .width('100%')
                .padding({ top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })
                .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
              })
            }

            // Status
            Row() {
              Text('健康状态').fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_HINT)
              Blank()
              Text(this.record.healthStatus === 'healthy' ? '健康' : this.record.healthStatus === 'attention' ? '需关注' : '有异常')
                .fontSize(Constants.FONT_MD)
                .fontColor(this.record.healthStatus === 'healthy' ? Constants.COLOR_SUCCESS : this.record.healthStatus === 'attention' ? Constants.COLOR_WARNING : Constants.COLOR_DANGER)
            }
            .width('100%')
            .padding({ top: Constants.SPACE_MD })
            .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })

            if (this.record.allergies) {
              this.DetailRow('过敏史', this.record.allergies)
            }
            if (this.record.medicalHistory) {
              this.DetailRow('病史', this.record.medicalHistory)
            }
          }
          .width('100%')
          .padding(Constants.SPACE_LG)
          .backgroundColor(Constants.COLOR_WHITE)
          .borderRadius(Constants.CARD_RADIUS)
          .border({ width: 1, color: Constants.COLOR_BORDER })
          .margin(Constants.SPACE_LG)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  MetricCol(label: string, value: string) {
    Column() {
      Text(label).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_HINT)
      Text(value).fontSize(Constants.FONT_XL).fontWeight(FontWeight.Bold).fontColor(Constants.COLOR_TEXT_PRIMARY).margin({ top: 4 })
    }
    .layoutWeight(1)
    .padding(Constants.SPACE_MD)
    .backgroundColor(Constants.COLOR_DIVIDER)
    .borderRadius(6)
    .margin({ left: 2, right: 2 })
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
