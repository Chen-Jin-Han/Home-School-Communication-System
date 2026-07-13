import { Constants } from '../../utils/Constants';
import { ChatService } from '../../services/ChatService';
import { Conversation } from '../../models/ChatModel';
import { ConversationItem } from '../../components/list/ConversationItem';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

@Entry
@Component
struct ConversationListPage {
  @State conversations: Conversation[] = [];
  @State loading: boolean = true;
  private isFirstShow: boolean = true;

  async aboutToAppear(): Promise<void> {
    await this.loadConversations();
  }

  onPageShow(): void {
    if (this.isFirstShow) {
      this.isFirstShow = false;
      return;
    }
    this.loadConversations();
  }

  private async loadConversations(): Promise<void> {
    const res = await ChatService.getConversations();
    this.conversations = res.code === 0 && res.data ? res.data : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '消息' }) {
        Button('+')
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .height(32)
          .width(32)
          .onClick(() => { RouterUtil.toSelectContact(); })
      }

      if (this.loading) {
        LoadingView()
      } else if ((this.conversations || []).length === 0) {
        EmptyView({ message: '暂无消息，点击右上角发起会话' })
      } else {
        List() {
          ForEach(this.conversations || [], (conv: Conversation) => {
            ListItem() {
              ConversationItem({ conversation: conv, onTap: () => { RouterUtil.toChat(conv.id, conv.name); } })
            }
          }, (c: Conversation) => c.id)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .divider({ strokeWidth: 0.5, color: Constants.COLOR_DIVIDER })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }
}
