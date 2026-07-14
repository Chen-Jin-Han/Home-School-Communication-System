import { Conversation } from '../../models/ChatModel';
import { Constants } from '../../utils/Constants';
import { DateUtil } from '../../utils/DateUtil';
import { AppBadge } from '../common/Badge';

@Component
export struct ConversationItem {
  @Prop conversation: Conversation;
  onTap?: () => void;

  build() {
    Row() {
      Stack() {
        Column() {
          Text(this.conversation.name.charAt(0))
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_WHITE)
            .fontWeight(FontWeight.Bold)
        }
        .width(Constants.AVATAR_MD)
        .height(Constants.AVATAR_MD)
        .borderRadius(Constants.AVATAR_MD / 2)
        .backgroundColor(Constants.COLOR_PRIMARY)
        .justifyContent(FlexAlign.Center)

        if (this.conversation.unreadCount > 0) {
          AppBadge({ count: this.conversation.unreadCount })
            .position({ x: 30, y: -4 })
        }
      }

      Column() {
        Row() {
          Text(this.conversation.name)
            .fontSize(Constants.FONT_LG)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
          Text(DateUtil.timeAgo(this.conversation.updatedAt))
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
        }
        .width('100%')

        if (this.conversation.lastMessage) {
          Text(this.conversation.lastMessage.content)
            .fontSize(Constants.FONT_MD)
            .fontColor(Constants.COLOR_TEXT_HINT)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .margin({ top: 4 })
        }
      }
      .layoutWeight(1)
      .margin({ left: Constants.SPACE_MD })
    }
    .width('100%')
    .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })
    .backgroundColor(Constants.COLOR_WHITE)
    .onClick(() => {
      if (this.onTap) {
        this.onTap();
      }
    })
  }
}
