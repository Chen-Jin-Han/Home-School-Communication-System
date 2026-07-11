import { promptAction } from '@kit.ArkUI';
import { UserStore } from '../store/UserStore';
import { AuthService } from '../services/AuthService';
import { RouterUtil } from '../utils/RouterUtil';
import { Constants } from '../utils/Constants';
import { UserRole } from '../models/UserModel';

interface QuickAccount {
  label: string;
  phone: string;
  password: string;
}

@Entry
@Component
struct LoginPage {
  @State phone: string = '13800000001';
  @State password: string = '123456';
  @State loading: boolean = false;
  @State showPassword: boolean = false;

  build() {
    Column() {
      // Header
      Column() {
        Text('家校通')
          .fontSize(Constants.FONT_TITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_WHITE)
        Text('欢迎登录')
          .fontSize(Constants.FONT_LG)
          .fontColor('#FFFFFFAA')
          .margin({ top: Constants.SPACE_SM })
      }
      .width('100%')
      .height(180)
      .backgroundColor(Constants.COLOR_PRIMARY)
      .justifyContent(FlexAlign.Center)

      // Form
      Column() {
        // Phone
        Row() {
          Image($r('sys.symbol.phone'))
            .width(20)
            .height(20)
            .fillColor(Constants.COLOR_TEXT_HINT)
          TextInput({ placeholder: '请输入手机号', text: this.phone })
            .layoutWeight(1)
            .height(48)
            .fontSize(Constants.FONT_LG)
            .maxLength(11)
            .type(InputType.Number)
            .backgroundColor(Color.Transparent)
            .padding({ left: Constants.SPACE_MD })
            .onChange((v: string) => { this.phone = v; })
        }
        .width('100%')
        .height(48)
        .border({ width: { bottom: 0.5 }, color: Constants.COLOR_BORDER })

        // Password
        Row() {
          Image($r('sys.symbol.lock'))
            .width(20)
            .height(20)
            .fillColor(Constants.COLOR_TEXT_HINT)
          TextInput({ placeholder: '请输入密码', text: this.password })
            .layoutWeight(1)
            .height(48)
            .fontSize(Constants.FONT_LG)
            .maxLength(20)
            .type(this.showPassword ? InputType.Normal : InputType.Password)
            .backgroundColor(Color.Transparent)
            .padding({ left: Constants.SPACE_MD })
            .onChange((v: string) => { this.password = v; })
          Image(this.showPassword ? $r('sys.symbol.eye') : $r('sys.symbol.eye_slash'))
            .width(20)
            .height(20)
            .fillColor(Constants.COLOR_TEXT_HINT)
            .onClick(() => { this.showPassword = !this.showPassword; })
        }
        .width('100%')
        .height(48)
        .border({ width: { bottom: 0.5 }, color: Constants.COLOR_BORDER })
        .margin({ top: Constants.SPACE_MD })

        // Login button
        Button(this.loading ? '登录中...' : '登录')
          .width('100%')
          .height(48)
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .margin({ top: Constants.SPACE_XXL })
          .enabled(!this.loading)
          .onClick(() => { this.handleLogin(); })

        // Quick login hints
        Text('测试账号')
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: Constants.SPACE_XL })

        Row() {
          ForEach(
            [
              { label: '家长', phone: '13800000001', password: '123456' },
              { label: '学生', phone: '13800000002', password: '123456' },
              { label: '教师', phone: '13800000003', password: '123456' },
              { label: '领导', phone: '13800000004', password: '123456' },
            ],
            (item: QuickAccount) => {
              Button(item.label)
                .fontSize(Constants.FONT_SM)
                .fontColor(Constants.COLOR_PRIMARY)
                .backgroundColor('#E6F7FF')
                .borderRadius(14)
                .height(28)
                .margin({ left: Constants.SPACE_XS, right: Constants.SPACE_XS })
                .onClick(() => {
                  this.phone = item.phone;
                  this.password = item.password;
                })
            }
          )
        }
        .justifyContent(FlexAlign.Center)
        .margin({ top: Constants.SPACE_SM })
      }
      .padding({
        left: Constants.SPACE_XXL,
        right: Constants.SPACE_XXL,
        top: Constants.SPACE_XXL,
      })
      .layoutWeight(1)

      // Bottom: register link
      Row() {
        Text('还没有账号？')
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
        Text('立即注册')
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_PRIMARY)
          .fontWeight(FontWeight.Bold)
          .onClick(() => { RouterUtil.toRegister(); })
      }
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_WHITE)
  }

  async handleLogin(): Promise<void> {
    if (!this.phone) {
      promptAction.showToast({ message: '请输入手机号' });
      return;
    }
    if (!this.password) {
      promptAction.showToast({ message: '请输入密码' });
      return;
    }
    this.loading = true;
    const res = await AuthService.login({ phone: this.phone, password: this.password });
    this.loading = false;
    if (res.code === 0) {
      const store = UserStore.getInstance();
      await store.login(res.data.user, res.data.token);
      promptAction.showToast({ message: `欢迎, ${res.data.user.name}!` });
      RouterUtil.toHome(res.data.user.role);
    } else {
      promptAction.showToast({ message: res.message });
    }
  }
}
