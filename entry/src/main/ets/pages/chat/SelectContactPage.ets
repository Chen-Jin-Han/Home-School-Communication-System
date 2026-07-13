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

interface RoleFilterOption {
  value: string;
  label: string;
}

@Entry
@Component
struct SelectContactPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State @Watch('onKeywordChange') searchKeyword: string = '';
  @State @Watch('onFilterChange') selectedRoleFilter: string = 'all';
  @State addIdentifier: string = '';
  @State contacts: User[] = [];
  @State filteredContactList: User[] = [];
  @State loading: boolean = true;
  @State creating: boolean = false;
  @State adding: boolean = false;

  private roleFilterOptions: RoleFilterOption[] = [
    { value: 'all', label: '全部' },
    { value: 'teacher', label: '教师' },
    { value: 'parent', label: '家长' },
    { value: 'student', label: '学生' },
    { value: 'leader', label: '领导' },
  ];

  async aboutToAppear(): Promise<void> {
    await this.loadContacts();
  }

  async loadContacts(): Promise<void> {
    this.loading = true;
    const res = await UserService.getContacts();
    this.contacts = res.code === 0 && res.data ? res.data : [];
    this.filteredContactList = this.computeFilteredContacts();
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '选择联系人' })

      this.AddContactPanel()

      SearchBar({ value: $searchKeyword, placeholder: '搜索联系人...' })

      this.RoleFilterBar()

      if (this.loading) {
        LoadingView()
      } else if (this.filteredContactList.length === 0) {
        EmptyView({ message: this.searchKeyword.trim() ? '没有匹配的联系人' : '暂无联系人' })
      } else {
        List() {
          ForEach(this.filteredContactList, (contact: User) => {
            ListItem() {
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
          }, (c: User) => c.id)
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
  RoleFilterBar() {
    Row() {
      ForEach(this.roleFilterOptions, (opt: RoleFilterOption) => {
        Text(opt.label)
          .fontSize(Constants.FONT_SM)
          .fontColor(this.selectedRoleFilter === opt.value ? Constants.COLOR_WHITE : Constants.COLOR_TEXT_SECONDARY)
          .backgroundColor(this.selectedRoleFilter === opt.value ? Constants.COLOR_PRIMARY : Constants.COLOR_BG)
          .borderRadius(14)
          .height(28)
          .padding({ left: 12, right: 12 })
          .margin({ right: 8 })
          .onClick(() => {
            this.selectedRoleFilter = opt.value;
          })
      }, (opt: RoleFilterOption) => opt.value)
    }
    .width('100%')
    .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, bottom: Constants.SPACE_SM })
  }

  @Builder
  AddContactPanel() {
    Column() {
      Row() {
        TextInput({ placeholder: '输入手机号/邮箱/用户ID添加联系人', text: this.addIdentifier })
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .backgroundColor(Constants.COLOR_BG)
          .borderRadius(Constants.BUTTON_RADIUS)
          .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
          .onChange((value: string) => {
            this.addIdentifier = value;
          })

        Button(this.adding ? '...' : '添加')
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .height(40)
          .margin({ left: Constants.SPACE_SM })
          .enabled(!this.adding && this.addIdentifier.trim().length > 0)
          .onClick(() => {
            this.addContact();
          })
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
    .backgroundColor(Constants.COLOR_WHITE)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_BORDER })
  }

  onKeywordChange(): void {
    this.filteredContactList = this.computeFilteredContacts();
  }

  onFilterChange(): void {
    this.filteredContactList = this.computeFilteredContacts();
  }

  private computeFilteredContacts(): User[] {
    const keyword = this.searchKeyword.trim();
    const roleFilter = this.selectedRoleFilter;
    return (this.contacts || []).filter((item: User) => {
      if (roleFilter !== 'all' && item.role !== roleFilter) {
        return false;
      }
      if (!keyword) {
        return true;
      }
      return item.name.includes(keyword) ||
        (item.phone || '').includes(keyword) ||
        (item.email || '').includes(keyword) ||
        (item.className || '').includes(keyword);
    });
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

  private async addContact(): Promise<void> {
    if (this.adding) {
      return;
    }
    const identifier = this.addIdentifier.trim();
    if (!identifier) {
      promptAction.openToast({ message: '请输入联系人手机号、邮箱或用户ID' });
      return;
    }
    this.adding = true;
    try {
      const res = await UserService.addContact(identifier);
      if (res.code === 0 && res.data) {
        this.addIdentifier = '';
        await this.loadContacts();
        promptAction.openToast({ message: '联系人已添加' });
      } else {
        promptAction.openToast({ message: res.message || '添加联系人失败' });
      }
    } finally {
      this.adding = false;
    }
  }

  private async startChat(contact: User): Promise<void> {
    if (this.creating) {
      return;
    }
    this.creating = true;
    try {
      const res = await ChatService.createPrivateConversation(contact.id);
      if (res.code === 0 && res.data) {
        RouterUtil.toChat(res.data.id, res.data.name || contact.name);
      } else {
        promptAction.openToast({ message: res.message || '无法发起会话' });
      }
    } finally {
      this.creating = false;
    }
  }
}
