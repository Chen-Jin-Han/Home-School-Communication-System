import { Notice } from '../../models/NoticeModel';
import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';

@Component
export struct NoticeCard {
  @Prop notice: Notice;
  onTap?: () => void;

  build() {
    Column() {
      Row() {
        Text(this.notice.isTop ? '置顶' : this.getTypeLabel())
          .fontSize(Constants.FONT_SM)
          .fontColor(this.notice.isTop ? Constants.COLOR_DANGER : Constants.COLOR_PRIMARY)
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor(this.notice.isTop ? Constants.COLOR_TAG_DANGER_BG : Constants.COLOR_TAG_INFO_BG)
          .borderRadius(4)
        Blank()
        Text(DateUtil.timeAgo(this.notice.createdAt))
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
      }
      .width('100%')

      Text(this.notice.title)
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: Constants.SPACE_SM })
        .width('100%')

      Text(this.notice.summary)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: Constants.SPACE_XS })
        .width('100%')

      Row() {
        Text(this.notice.publisherName)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
        Blank()
        Text(`阅读 ${this.notice.viewCount}`)
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

  getTypeLabel(): string {
    switch (this.notice.type) {
      case 'notification': return '通知';
      case 'announcement': return '公告';
      case 'news': return '新闻';
      default: return '';
    }
  }
}
