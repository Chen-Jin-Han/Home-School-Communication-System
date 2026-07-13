import { Activity } from '../../models/ActivityModel';
import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';
import { ElementIcon } from '../common/ElementIcon';

@Component
export struct ActivityCard {
  @Prop activity: Activity;
  onTap?: () => void;

  build() {
    Column() {
      Row() {
        Text(this.getStatusLabel())
          .fontSize(Constants.FONT_SM)
          .fontColor(this.getStatusColor())
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor(this.getStatusBgColor())
          .borderRadius(4)
        Blank()
        Text(`${this.activity.participantCount}人参与`)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
      }
      .width('100%')

      Text(this.activity.title)
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: Constants.SPACE_SM })
        .width('100%')

      Row() {
        ElementIcon({ name: 'Location', iconSize: 14, color: Constants.COLOR_TEXT_HINT })
        Text(this.activity.location)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ left: 4 })
      }
      .margin({ top: Constants.SPACE_XS })

      Row() {
        ElementIcon({ name: 'Calendar', iconSize: 14, color: Constants.COLOR_TEXT_HINT })
        Text(`${DateUtil.formatDate(this.activity.startTime)} - ${DateUtil.formatDate(this.activity.endTime)}`)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ left: 4 })
      }
      .margin({ top: 2 })
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

  getStatusLabel(): string {
    switch (this.activity.status) {
      case 'upcoming': return '即将开始';
      case 'ongoing': return '进行中';
      case 'ended': return '已结束';
    }
  }

  getStatusColor(): string {
    switch (this.activity.status) {
      case 'upcoming': return Constants.COLOR_PRIMARY;
      case 'ongoing': return Constants.COLOR_SUCCESS;
      case 'ended': return Constants.COLOR_TEXT_HINT;
    }
  }

  getStatusBgColor(): string {
    switch (this.activity.status) {
      case 'upcoming': return '#E6F7FF';
      case 'ongoing': return '#F6FFED';
      case 'ended': return Constants.COLOR_DIVIDER;
    }
  }
}
