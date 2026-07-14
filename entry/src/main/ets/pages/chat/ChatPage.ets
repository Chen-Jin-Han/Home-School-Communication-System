import { router, promptAction } from '@kit.ArkUI';
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
  @State actionMessageId: string = '';
  @State recalling: boolean = false;
  private conversationId: string = '';
  private conversationName: string = '';
  private scroller: ListScroller = new ListScroller();
  private pollTimer: number = -1;
  private isSending: boolean = false;
  private isRefreshing: boolean = false;

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as ChatPageParams;
    if (!params || !params.conversationId) {
      router.back();
      return;
    }
    this.conversationId = params.conversationId;
    this.conversationName = params.name;
    const res = await ChatService.getMessages(this.conversationId, 1);
    this.messages = res.code === 0 && res.data ? (res.data.list || []) : [];
    this.loading = false;
    this.scrollToBottom();
    this.startPolling();
  }

  aboutToDisappear(): void {
    this.stopPolling();
  }

  private startPolling(): void {
    this.stopPolling();
    this.pollTimer = setInterval(() => {
      this.refreshMessages();
    }, 5000);
  }

  private stopPolling(): void {
    if (this.pollTimer !== -1) {
      clearInterval(this.pollTimer);
      this.pollTimer = -1;
    }
  }

  private async refreshMessages(): Promise<void> {
    if (this.loading || this.isSending || this.isRefreshing) {
      return;
    }
    this.isRefreshing = true;
    try {
      const res = await ChatService.getMessages(this.conversationId, 1);
      if (res.code === 0 && res.data) {
        const newMessages = res.data.list || [];
        if (newMessages.length !== this.messages.length || JSON.stringify(newMessages) !== JSON.stringify(this.messages)) {
          this.messages = newMessages;
          this.scrollToBottom();
        }
      }
    } finally {
      this.isRefreshing = false;
    }
  }

  private scrollToBottom(): void {
    if (this.messages.length > 0) {
      setTimeout(() => {
        this.scroller.scrollToIndex(this.messages.length - 1);
      }, 50);
    }
  }

  build() {
    Column() {
      AppNavBar({ title: this.conversationName })

      if (this.loading) {
        LoadingView()
      } else {
        List({ scroller: this.scroller }) {
          ForEach(this.messages || [], (msg: Message) => {
            ListItem() {
              this.MessageBubble(msg)
            }
          }, (msg: Message) => msg.id)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
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
          .onSubmit(() => { this.sendMessage(); })

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
        if (msg.status === 'recalled') {
          Text(msg.senderId === this.userStore.currentUser?.id ? '你撤回了一条消息' : '对方撤回了一条消息')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
            .padding({ left: 12, right: 12, top: 7, bottom: 7 })
            .borderRadius(12)
            .backgroundColor('#E8EDF3')
        } else {
          Text(msg.content)
            .fontSize(Constants.FONT_MD)
            .fontColor(msg.senderId === this.userStore.currentUser?.id ? Constants.COLOR_WHITE : Constants.COLOR_TEXT_PRIMARY)
            .padding(Constants.SPACE_MD)
            .borderRadius(12)
            .backgroundColor(msg.senderId === this.userStore.currentUser?.id ? Constants.COLOR_PRIMARY : Constants.COLOR_WHITE)
            .gesture(LongPressGesture().onAction(() => {
              if (this.canRecall(msg)) {
                this.actionMessageId = this.actionMessageId === msg.id ? '' : msg.id;
              }
            }))
        }
        if (this.actionMessageId === msg.id && this.canRecall(msg)) {
          Button(this.recalling ? '撤回中' : '撤回')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_DANGER)
            .backgroundColor(Constants.COLOR_WHITE)
            .border({ width: 1, color: Constants.COLOR_BORDER })
            .borderRadius(12)
            .height(30)
            .margin({ top: 6 })
            .enabled(!this.recalling)
            .onClick(() => {
              this.recallMessage(msg);
            })
        }
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

  private canRecall(msg: Message): boolean {
    if (msg.status === 'recalled') {
      return false;
    }
    if (msg.senderId !== this.userStore.currentUser?.id) {
      return false;
    }
    const createdAt = DateUtil.toMillis(msg.createdAt);
    return createdAt > 0 && Date.now() - createdAt <= 2 * 60 * 1000;
  }

  private async recallMessage(msg: Message): Promise<void> {
    if (this.recalling || !this.canRecall(msg)) {
      return;
    }
    this.recalling = true;
    const res = await ChatService.recallMessage(this.conversationId, msg.id);
    this.recalling = false;
    this.actionMessageId = '';
    if (res.code === 0 && res.data) {
      this.messages = (this.messages || []).map((item: Message) => item.id === msg.id ? res.data! : item);
    } else {
      promptAction.openToast({ message: res.message || '撤回失败' });
    }
  }

  async sendMessage(): Promise<void> {
    if (!this.inputText) return;
    if (this.isSending) return;
    const store = this.userStore;
    const content = this.inputText;
    const msg: Message = {
      id: `msg_${Date.now()}`,
      conversationId: this.conversationId,
      senderId: store.currentUser?.id || '',
      senderName: store.currentUser?.name || '',
      senderAvatar: '',
      type: 'text',
      content: content,
      createdAt: Date.now(),
      status: 'sent',
    };
    this.isSending = true;
    this.messages = [...(this.messages || []), msg];
    this.inputText = '';
    this.scrollToBottom();
    const res = await ChatService.sendMessage(msg);
    this.isSending = false;
    if (res.code === 0 && res.data) {
      const arr = [...(this.messages || [])];
      if (arr.length > 0) {
        arr[arr.length - 1] = res.data;
      }
      this.messages = arr;
    } else {
      promptAction.openToast({ message: res.message || '发送失败' });
      const arr = [...(this.messages || [])];
      if (arr.length > 0) {
        arr.length = arr.length - 1;
      }
      this.messages = arr;
      this.inputText = content;
    }
  }
}
