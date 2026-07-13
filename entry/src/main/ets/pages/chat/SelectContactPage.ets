import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { User } from '../../models/UserModel';
import { UserService } from '../../services/UserService';
import { ChatService } from '../../services/ChatService';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { SearchBar } from '../../components/common/SearchBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

@Entry
@Component
struct SelectContactPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State searchKeyword: string = '';
  @State contacts: User[] = [];
  @State loading: boolean = true;
  @State creating: boolean = false;

  async aboutToAppear(): Promise<void> {
    await this.loadContacts();
  }

  async loadContacts(): Promise<void> {
    this.loading = true;
    const res = await UserService.getContacts();
    this.contacts = res.code === 0 && res.data ? res.data : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '选择联系人' })
      SearchBar({ value: $searchKeyword, placeholder: '搜索联系人...' })

      if (this.loading) {
        LoadingView()
      } else if (this.filteredContacts().length === 0) {
        EmptyView({ message: '暂无联系人' })
      } else {
        List() {
          ForEach(this.filteredContacts(), (contact: User) => {
            ListItem() {
              this.ContactRow(contact)
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

  @Builder
  ContactRow(contact: User) {
    Row() {
      Column() {
        Text((contact.name || '?').charAt(0))
          .fontSize(18)
          .fontColor(Constants.COLOR_WHITE)
          .fontWeight(FontWeight.Bold)
      }
      .width(42)
      .height(42)
      .borderRadius(21)
      .backgroundColor(Constants.COLOR_PRIMARY)
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(contact.name)
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
        Text(`${this.roleLabel(contact.role)}${contact.className ? ' · ' + contact.className : ''}`)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 3 })
      }
      .margin({ left: Constants.SPACE_MD })
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('发起')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_PRIMARY)
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD, top: 6, bottom: 6 })
        .backgroundColor(Constants.COLOR_PRIMARY_SOFT)
        .borderRadius(Constants.BUTTON_RADIUS)
    }
    .width('100%')
    .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })
    .backgroundColor(Constants.COLOR_WHITE)
    .onClick(() => {
      this.startChat(contact);
    })
  }

  private filteredContacts(): User[] {
    const keyword = this.searchKeyword.trim();
    if (!keyword) {
      return this.contacts || [];
    }
    return (this.contacts || []).filter((item: User) =>
      item.name.includes(keyword) ||
      (item.phone || '').includes(keyword) ||
      (item.className || '').includes(keyword)
    );
  }

  private roleLabel(role: string): string {
    if (role === 'teacher') {
      return '教师';
    }
    if (role === 'leader') {
      return '领导';
    }
    if (role === 'student') {
      return '学生';
    }
    return '家长';
  }

  private async startChat(contact: User): Promise<void> {
    if (this.creating) {
      return;
    }
    this.creating = true;
    const res = await ChatService.createPrivateConversation(contact.id);
    this.creating = false;
    if (res.code === 0 && res.data) {
      RouterUtil.toChat(res.data.id, res.data.name || contact.name);
    } else {
      promptAction.showToast({ message: res.message || '无法发起会话' });
    }
  }
}
