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

  async aboutToAppear(): Promise<void> {
    const res = await ChatService.getConversations();
    this.conversations = res.data;
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '消息' })
      if (this.loading) {
        LoadingView()
      } else if (this.conversations.length === 0) {
        EmptyView({ message: '暂无消息' })
      } else {
        List() {
          ForEach(this.conversations, (conv: Conversation) => {
            ListItem() {
              ConversationItem({ conversation: conv, onTap: () => { RouterUtil.toChat(conv.id, conv.name); } })
            }
          })
        }
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: Constants.COLOR_DIVIDER })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }
}
