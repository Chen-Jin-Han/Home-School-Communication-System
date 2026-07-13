import { promptAction } from '@kit.ArkUI';
import { UserStore } from '../store/UserStore';
import { AuthService } from '../services/AuthService';
import { RouterUtil } from '../utils/RouterUtil';
import { Constants } from '../utils/Constants';

interface QuickAccount {
  label: string;
  account: string;
  password: string;
}

@Entry
@Component
struct LoginPage {
  @State account: string = 'parent@huadee.test';
  @State password: string = '123456';
  @State loading: boolean = false;

  private quickAccounts: QuickAccount[] = [
    { label: '家长', account: 'parent@huadee.test', password: '123456' },
    { label: '学生', account: 'student@huadee.test', password: '123456' },
    { label: '教师', account: 'teacher@huadee.test', password: '123456' },
    { label: '领导', account: 'leader@huadee.test', password: '123456' },
  ];

  build() {
    Column() {
      Scroll() {
        Column() {
          this.BrandHeader()
          this.LoginCard()
          this.RegisterLink()
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 24 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F4F8FC')
  }

  @Builder
  BrandHeader() {
    Column() {
      Image($r('app.media.app_logo'))
        .width(92)
        .height(92)
        .borderRadius(24)
        .margin({ top: 36 })

      Text('家校通')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#174A7C')
        .margin({ top: 16 })

      Text('华迪 HuaDee')
        .fontSize(16)
        .fontColor('#4A90D9')
        .margin({ top: 6 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  LoginCard() {
    Column() {
      Text('登录')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .width('100%')

      Text('使用手机号或邮箱进入家校协同空间')
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .width('100%')
        .margin({ top: 6, bottom: 22 })

      this.InputRow('账号', '手机号 / 邮箱', this.account, false, (value: string) => {
        this.account = value;
      })

      this.PasswordRow()

      Button(this.loading ? '登录中...' : '登录')
        .width('100%')
        .height(48)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_WHITE)
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#4A90D9')
        .borderRadius(12)
        .margin({ top: 24 })
        .enabled(!this.loading)
        .onClick(() => {
          this.handleLogin();
        })

      Text('测试账号')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .width('100%')
        .margin({ top: 22, bottom: 10 })

      Grid() {
        ForEach(this.quickAccounts, (item: QuickAccount) => {
          GridItem() {
            Button(item.label)
              .width('100%')
              .height(36)
              .fontSize(Constants.FONT_MD)
              .fontColor(this.account === item.account ? Constants.COLOR_WHITE : '#2469A8')
              .backgroundColor(this.account === item.account ? '#4A90D9' : '#E7F2FD')
              .borderRadius(18)
              .onClick(() => {
                this.account = item.account;
                this.password = item.password;
              })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(8)
      .rowsGap(8)
      .height(40)
    }
    .width('100%')
    .padding(20)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(18)
    .shadow({ radius: 18, color: '#1F4A7C18', offsetY: 8 })
    .margin({ top: 28 })
  }

  @Builder
  InputRow(label: string, placeholder: string, value: string, numberOnly: boolean, onValueChange: (value: string) => void) {
    Column() {
      Text(label)
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .width('100%')
        .margin({ bottom: 8 })

      TextInput({ placeholder: placeholder, text: value })
        .width('100%')
        .height(48)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .placeholderColor('#A8B3BF')
        .backgroundColor('#F6F9FC')
        .borderRadius(12)
        .padding({ left: 14, right: 14 })
        .type(numberOnly ? InputType.Number : InputType.Normal)
        .onChange((text: string) => {
          onValueChange(text);
        })
    }
    .width('100%')
  }

  @Builder
  PasswordRow() {
    Column() {
      Text('密码')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .width('100%')
        .margin({ top: 16, bottom: 8 })
      TextInput({ placeholder: '请输入密码', text: this.password })
        .height(48)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .placeholderColor('#A8B3BF')
        .backgroundColor(Color.Transparent)
        .type(InputType.Password)
        .onChange((text: string) => {
          this.password = text;
        })
        .width('100%')
        .height(48)
        .padding({ left: 14, right: 14 })
        .backgroundColor('#F6F9FC')
        .borderRadius(12)
    }
    .width('100%')
  }

  @Builder
  RegisterLink() {
    Row() {
      Text('还没有账号？')
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_HINT)
      Text('立即注册')
        .fontSize(Constants.FONT_MD)
        .fontColor('#4A90D9')
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          RouterUtil.toRegister();
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .margin({ top: 20 })
  }

  async handleLogin(): Promise<void> {
    const account = this.account.trim();
    if (!account) {
      promptAction.showToast({ message: '请输入手机号或邮箱' });
      return;
    }
    if (!this.password) {
      promptAction.showToast({ message: '请输入密码' });
      return;
    }

    this.loading = true;
    const res = await AuthService.login({ account: account, password: this.password });
    this.loading = false;

    if (res.code === 0) {
      const store = UserStore.getInstance();
      await store.login(res.data.user, res.data.token);
      promptAction.showToast({ message: `欢迎，${res.data.user.name}` });
      RouterUtil.toHome(res.data.user.role);
    } else {
      promptAction.showToast({ message: res.message || '登录失败' });
    }
  }
}
