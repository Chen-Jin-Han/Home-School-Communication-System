import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { UserStore } from '../../store/UserStore';
import { UserService } from '../../services/UserService';
import { User } from '../../models/UserModel';
import { AppNavBar } from '../../components/common/AppNavBar';
import { Avatar } from '../../components/common/Avatar';
import { ElementIcon } from '../../components/common/ElementIcon';

@Entry
@Component
struct PersonalProfilePage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State loading: boolean = false;
  @State saving: boolean = false;
  @State formName: string = '';
  @State formPhone: string = '';
  @State formEmail: string = '';
  @State formSubject: string = '';
  @State formPosition: string = '';

  async aboutToAppear(): Promise<void> {
    await this.refreshProfile();
  }

  async refreshProfile(): Promise<void> {
    const current = this.userStore.currentUser;
    if (!current) {
      return;
    }
    this.fillForm(current);
    this.loading = true;
    const res = await UserService.getProfile(current.id);
    this.loading = false;
    if (res.code === 0 && res.data) {
      await this.userStore.updateCurrentUser(res.data);
      this.fillForm(res.data);
    }
  }

  build() {
    Column() {
      AppNavBar({ title: '个人信息' })

      Scroll() {
        Column() {
          this.ProfileHeader()
          this.EditSection()
          this.ReadonlySection()
          this.ActionBar()
          Blank().height(24)
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 14, bottom: 24 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  ProfileHeader() {
    Row() {
      Avatar({ name: this.userStore.currentUser?.name || '?', avatarSize: Constants.AVATAR_LG })

      Column() {
        Row() {
          Text(this.userStore.currentUser?.name || '未登录')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.getRoleLabel())
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_PRIMARY)
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .backgroundColor(Constants.COLOR_PRIMARY_SOFT)
            .borderRadius(8)
            .margin({ left: 8 })
        }
        .width('100%')

        Text(this.userStore.currentUser?.schoolName || '未绑定学校')
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 6 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 14 })
      .layoutWeight(1)
    }
    .width('100%')
    .padding(18)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
  }

  @Builder
  EditSection() {
    Column() {
      this.SectionTitle('可编辑资料', 'Edit')
      this.InputRow('姓名', '请输入姓名', this.formName, InputType.Normal, (value: string) => {
        this.formName = value;
      })
      this.InputRow('手机号', '请输入手机号', this.formPhone, InputType.Number, (value: string) => {
        this.formPhone = value;
      })
      this.InputRow('邮箱', '请输入邮箱', this.formEmail, InputType.Normal, (value: string) => {
        this.formEmail = value;
      })
      if (this.userStore.isTeacher()) {
        this.InputRow('任教学科', '请输入任教学科', this.formSubject, InputType.Normal, (value: string) => {
          this.formSubject = value;
        })
      }
      if (this.userStore.isLeader() || this.userStore.isTeacher()) {
        this.InputRow('职务', '请输入职务', this.formPosition, InputType.Normal, (value: string) => {
          this.formPosition = value;
        })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 8 })
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .margin({ top: 14 })
  }

  @Builder
  ReadonlySection() {
    Column() {
      this.SectionTitle('组织信息', 'School')
      this.ReadonlyRow('学校', this.userStore.currentUser?.schoolName || '未绑定')
      if (this.userStore.currentUser?.className) {
        this.ReadonlyRow('班级', this.userStore.currentUser?.className || '')
      }
      if (this.userStore.isParent() && this.userStore.currentUser?.childNames) {
        this.ReadonlyRow('关联学生', this.userStore.currentUser?.childNames?.join('、') || '未绑定')
      }
      this.ReadonlyRow('用户编号', this.userStore.currentUser?.id || '--')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 8 })
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .margin({ top: 14 })
  }

  @Builder
  SectionTitle(title: string, icon: string) {
    Row() {
      ElementIcon({ name: icon, size: 18, color: Constants.COLOR_PRIMARY })
      Text(title)
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .margin({ left: 8 })
      Blank()
    }
    .width('100%')
    .margin({ bottom: 10 })
  }

  @Builder
  InputRow(label: string, placeholder: string, value: string, inputType: InputType, onChange: (value: string) => void) {
    Column() {
      Text(label)
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .width('100%')
        .margin({ bottom: 7 })

      TextInput({ placeholder: placeholder, text: value })
        .width('100%')
        .height(44)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .placeholderColor(Constants.COLOR_TEXT_HINT)
        .backgroundColor('#F8FAFC')
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 1, color: Constants.COLOR_BORDER })
        .padding({ left: 12, right: 12 })
        .type(inputType)
        .enabled(!this.saving)
        .onChange((text: string) => {
          onChange(text);
        })
    }
    .width('100%')
    .margin({ bottom: 14 })
  }

  @Builder
  ReadonlyRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .width(88)
      Text(value || '--')
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.End)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(40)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
  }

  @Builder
  ActionBar() {
    Row() {
      Button('重置')
        .layoutWeight(1)
        .height(46)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .backgroundColor(Constants.COLOR_WHITE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 1, color: Constants.COLOR_BORDER })
        .enabled(!this.saving)
        .onClick(() => {
          if (this.userStore.currentUser) {
            this.fillForm(this.userStore.currentUser);
          }
        })

      Button(this.saving ? '保存中...' : '保存资料')
        .layoutWeight(1)
        .height(46)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_WHITE)
        .backgroundColor(Constants.COLOR_PRIMARY)
        .borderRadius(Constants.BUTTON_RADIUS)
        .margin({ left: 12 })
        .enabled(!this.saving)
        .onClick(() => {
          this.handleSave();
        })
    }
    .width('100%')
    .margin({ top: 18 })
  }

  private fillForm(user: User): void {
    this.formName = user.name || '';
    this.formPhone = user.phone || '';
    this.formEmail = user.email || '';
    this.formSubject = user.subject || '';
    this.formPosition = user.position || '';
  }

  private async handleSave(): Promise<void> {
    const current = this.userStore.currentUser;
    if (!current) {
      promptAction.showToast({ message: '请先登录' });
      return;
    }

    const name = this.formName.trim();
    const phone = this.formPhone.trim();
    const email = this.formEmail.trim();
    if (!name) {
      promptAction.showToast({ message: '姓名不能为空' });
      return;
    }
    if (email && email.indexOf('@') < 0) {
      promptAction.showToast({ message: '请输入正确的邮箱' });
      return;
    }

    const payload: User = {
      ...current,
      name: name,
      phone: phone,
      email: email || undefined,
      subject: this.formSubject.trim() || undefined,
      position: this.formPosition.trim() || undefined,
    };

    this.saving = true;
    const res = await UserService.updateProfile(payload);
    this.saving = false;
    if (res.code === 0 && res.data) {
      await this.userStore.updateCurrentUser(res.data);
      this.fillForm(res.data);
      promptAction.showToast({ message: '个人信息已保存' });
    } else {
      promptAction.showToast({ message: res.message || '保存失败' });
    }
  }

  private getRoleLabel(): string {
    const store = this.userStore;
    if (store.isParent()) return '家长';
    if (store.isStudent()) return '学生';
    if (store.isTeacher()) return '教师';
    if (store.isLeader()) return '领导';
    return '用户';
  }
}
