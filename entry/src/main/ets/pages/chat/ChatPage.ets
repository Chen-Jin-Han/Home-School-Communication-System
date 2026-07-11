import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { ChatService } from '../../services/ChatService';
import { Message } from '../../models/ChatModel';
import { UserStore } from '../../store/UserStore';
import { DateUtil } from '../../utils/DateUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { Avatar } from '../../components/common/Avatar';

interface ChatPageParams {
  conversationId: string;
  name: string;
}

@Entry
@Component
struct ChatPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State messages: Message[] = [];
  @State loading: boolean = true;
  @State inputText: string = '';
  private conversationId: string = '';
  private conversationName: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as ChatPageParams;
    this.conversationId = params.conversationId;
    this.conversationName = params.name;
    const res = await ChatService.getMessages(this.conversationId, 1);
    this.messages = res.data.list;
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: this.conversationName })

      if (this.loading) {
        LoadingView()
      } else {
        List() {
          ForEach(this.messages, (msg: Message) => {
            ListItem() {
              this.MessageBubble(msg)
            }
          })
        }
        .layoutWeight(1)
        .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG })
      }

      // Input bar
      Row() {
        TextInput({ placeholder: '输入消息...', text: this.inputText })
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .backgroundColor(Constants.COLOR_BG)
          .borderRadius(20)
          .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
          .onChange((v: string) => { this.inputText = v; })

        Button('发送')
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(this.inputText ? Constants.COLOR_PRIMARY : Constants.COLOR_BORDER)
          .borderRadius(Constants.BUTTON_RADIUS)
          .height(40)
          .margin({ left: Constants.SPACE_SM })
          .enabled(!!this.inputText)
          .onClick(() => { this.sendMessage(); })
      }
      .width('100%')
      .padding(Constants.SPACE_MD)
      .backgroundColor(Constants.COLOR_WHITE)
      .border({ width: { top: 0.5 }, color: Constants.COLOR_BORDER })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  MessageBubble(msg: Message) {
    Row() {
      if (msg.senderId !== this.userStore.currentUser?.id) {
        Avatar({ name: msg.senderName, avatarSize: 36 })
      }
      Column() {
        if (msg.senderId !== this.userStore.currentUser?.id) {
          Text(msg.senderName)
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
            .margin({ bottom: 4 })
        }
        Text(msg.content)
          .fontSize(Constants.FONT_MD)
          .fontColor(msg.senderId === this.userStore.currentUser?.id ? Constants.COLOR_WHITE : Constants.COLOR_TEXT_PRIMARY)
          .padding(Constants.SPACE_MD)
          .borderRadius(12)
          .backgroundColor(msg.senderId === this.userStore.currentUser?.id ? Constants.COLOR_PRIMARY : Constants.COLOR_WHITE)
        Text(DateUtil.formatTime(msg.createdAt))
          .fontSize(10)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 2 })
      }
      .alignItems(msg.senderId === this.userStore.currentUser?.id ? HorizontalAlign.End : HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: Constants.SPACE_SM, right: Constants.SPACE_SM })
    }
    .width('100%')
    .justifyContent(msg.senderId === this.userStore.currentUser?.id ? FlexAlign.End : FlexAlign.Start)
    .padding({ top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
  }

  async sendMessage(): Promise<void> {
    if (!this.inputText) return;
    const store = this.userStore;
    const msg: Message = {
      id: `msg_${Date.now()}`,
      conversationId: this.conversationId,
      senderId: store.currentUser?.id || '',
      senderName: store.currentUser?.name || '',
      senderAvatar: '',
      type: 'text',
      content: this.inputText,
      createdAt: Date.now(),
      status: 'sent',
    };
    this.messages = [...this.messages, msg];
    this.inputText = '';
    await ChatService.sendMessage(msg);
  }
}
