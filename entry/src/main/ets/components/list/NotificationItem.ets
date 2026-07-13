import { Notice } from '../../models/NoticeModel';
import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';
import { ElementIcon } from '../common/ElementIcon';

@Component
export struct NotificationItem {
  @Prop notice: Notice;
  onTap?: () => void;

  build() {
    Row() {
      Column() {
        Row() {
          if (this.notice.isTop) {
            Text('置顶')
              .fontSize(10)
              .fontColor(Constants.COLOR_DANGER)
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .backgroundColor('#FFF1F0')
              .borderRadius(3)
              .margin({ right: Constants.SPACE_SM })
          }
          Text(this.notice.title)
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
          Text(DateUtil.timeAgo(this.notice.createdAt))
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
        }
        .width('100%')

        Row() {
          Text(this.getTypeLabel())
            .fontSize(10)
            .fontColor(Constants.COLOR_PRIMARY)
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .backgroundColor('#E6F7FF')
            .borderRadius(3)
          Text(this.notice.publisherName)
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
            .margin({ left: Constants.SPACE_SM })
        }
        .width('100%')
        .margin({ top: Constants.SPACE_XS })
      }
      .layoutWeight(1)

      ElementIcon({ name: 'ChevronRight', iconSize: 16, color: Constants.COLOR_TEXT_HINT })
        .margin({ left: Constants.SPACE_SM })
    }
    .width('100%')
    .padding(Constants.SPACE_MD)
    .backgroundColor(Constants.COLOR_WHITE)
    .onClick(() => {
      if (this.onTap) {
        this.onTap();
      }
    })
    .border({
      width: { bottom: 0.5 },
      color: Constants.COLOR_DIVIDER,
    })
  }

  getTypeLabel(): string {
    switch (this.notice.type) {
      case 'notification': return '通知';
      case 'announcement': return '公告';
      case 'news': return '新闻';
    }
  }
}
