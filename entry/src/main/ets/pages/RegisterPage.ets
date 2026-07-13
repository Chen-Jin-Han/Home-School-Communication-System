import { promptAction } from '@kit.ArkUI';
import { Constants } from '../utils/Constants';
import { RouterUtil } from '../utils/RouterUtil';
import { UserRole, RegisterParams } from '../models/UserModel';
import { AuthService } from '../services/AuthService';

interface RoleOption {
  role: UserRole;
  label: string;
}

@Entry
@Component
struct RegisterPage {
  @State name: string = '';
  @State phone: string = '';
  @State email: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State selectedRole: UserRole = UserRole.PARENT;
  @State loading: boolean = false;

  private roleOptions: RoleOption[] = [
    { role: UserRole.PARENT, label: '家长' },
    { role: UserRole.STUDENT, label: '学生' },
    { role: UserRole.TEACHER, label: '教师' },
  ];

  build() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(34)
          .fontColor('#174A7C')
          .width(44)
          .height(44)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            RouterUtil.toLogin();
          })

        Text('创建账号')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
          .layoutWeight(1)

        Blank().width(44)
      }
      .width('100%')
      .height(56)
      .padding({ left: 12, right: 12 })
      .backgroundColor('#F4F8FC')

      Scroll() {
        Column() {
          Column() {
            Text('加入家校通')
              .fontSize(26)
              .fontWeight(FontWeight.Bold)
              .fontColor('#174A7C')
              .width('100%')

            Text('邮箱登录不产生额外费用，当前不启用邮箱验证码')
              .fontSize(Constants.FONT_MD)
              .fontColor(Constants.COLOR_TEXT_HINT)
              .width('100%')
              .margin({ top: 8, bottom: 22 })

            this.TextField('姓名', '请输入真实姓名', this.name, InputType.Normal, (value: string) => {
              this.name = value;
            })
            this.TextField('手机号', '可选，用于手机号登录', this.phone, InputType.Number, (value: string) => {
              this.phone = value;
            })
            this.TextField('邮箱', '可选，用于邮箱登录', this.email, InputType.Normal, (value: string) => {
              this.email = value;
            })
            this.TextField('密码', '至少 6 位', this.password, InputType.Password, (value: string) => {
              this.password = value;
            })
            this.TextField('确认密码', '再次输入密码', this.confirmPassword, InputType.Password, (value: string) => {
              this.confirmPassword = value;
            })

            Text('身份')
              .fontSize(Constants.FONT_SM)
              .fontColor(Constants.COLOR_TEXT_HINT)
              .width('100%')
              .margin({ top: 16, bottom: 8 })

            Row() {
              ForEach(this.roleOptions, (item: RoleOption) => {
                Button(item.label)
                  .layoutWeight(1)
                  .height(38)
                  .fontSize(Constants.FONT_MD)
                  .fontColor(this.selectedRole === item.role ? Constants.COLOR_WHITE : '#2469A8')
                  .backgroundColor(this.selectedRole === item.role ? '#4A90D9' : '#E7F2FD')
                  .borderRadius(19)
                  .margin({ right: 8 })
                  .onClick(() => {
                    this.selectedRole = item.role;
                  })
              })
            }
            .width('100%')

            Button(this.loading ? '提交中...' : '注册')
              .width('100%')
              .height(48)
              .fontSize(Constants.FONT_LG)
              .fontColor(Constants.COLOR_WHITE)
              .backgroundColor('#4A90D9')
              .borderRadius(12)
              .margin({ top: 26 })
              .enabled(!this.loading)
              .onClick(() => {
                this.handleRegister();
              })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(Constants.COLOR_WHITE)
          .borderRadius(18)
          .shadow({ radius: 18, color: '#1F4A7C18', offsetY: 8 })

          Row() {
            Text('已有账号？')
              .fontSize(Constants.FONT_MD)
              .fontColor(Constants.COLOR_TEXT_HINT)
            Text('去登录')
              .fontSize(Constants.FONT_MD)
              .fontColor('#4A90D9')
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                RouterUtil.back();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: 20, bottom: 24 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 12 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F4F8FC')
  }

  @Builder
  TextField(label: string, placeholder: string, value: string, inputType: InputType, onValueChange: (value: string) => void) {
    Column() {
      Text(label)
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .width('100%')
        .margin({ top: 14, bottom: 8 })

      TextInput({ placeholder: placeholder, text: value })
        .width('100%')
        .height(46)
        .fontSize(Constants.FONT_LG)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .placeholderColor('#A8B3BF')
        .backgroundColor('#F6F9FC')
        .borderRadius(12)
        .padding({ left: 14, right: 14 })
        .type(inputType)
        .onChange((text: string) => {
          onValueChange(text);
        })
    }
    .width('100%')
  }

  async handleRegister(): Promise<void> {
    const phone = this.phone.trim();
    const email = this.email.trim();

    if (!this.name.trim()) {
      promptAction.showToast({ message: '请输入姓名' });
      return;
    }
    if (!phone && !email) {
      promptAction.showToast({ message: '手机号和邮箱至少填写一个' });
      return;
    }
    if (email && email.indexOf('@') < 0) {
      promptAction.showToast({ message: '请输入正确的邮箱' });
      return;
    }
    if (this.password.length < 6) {
      promptAction.showToast({ message: '密码至少 6 位' });
      return;
    }
    if (this.password !== this.confirmPassword) {
      promptAction.showToast({ message: '两次密码不一致' });
      return;
    }

    const params: RegisterParams = {
      phone: phone,
      email: email,
      password: this.password,
      name: this.name.trim(),
      role: this.selectedRole,
      schoolId: '1',
    };

    this.loading = true;
    const res = await AuthService.register(params);
    this.loading = false;

    if (res.code === 0) {
      promptAction.showToast({ message: '注册成功，请登录' });
      RouterUtil.back();
    } else {
      promptAction.showToast({ message: res.message || '注册失败' });
    }
  }
}
