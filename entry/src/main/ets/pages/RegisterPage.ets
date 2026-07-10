import { promptAction } from '@kit.ArkUI';
import { Constants } from '../utils/Constants';
import { RouterUtil } from '../utils/RouterUtil';
import { UserRole } from '../models/UserModel';
import { AppNavBar } from '../components/common/AppNavBar';
import { FormRow } from '../components/form/FormRow';
import { FormTextInput } from '../components/form/FormTextInput';

interface RoleOption {
  role: string;
  label: string;
}

@Entry
@Component
struct RegisterPage {
  @State name: string = '';
  @State phone: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State selectedRole: string = UserRole.PARENT;

  build() {
    Column() {
      AppNavBar({ title: '注册账号' })

      Scroll() {
        Column() {
          FormRow({ label: '姓名', required: true }) {
            FormTextInput({ value: this.name, placeholder: '请输入真实姓名', maxLength: 20 })
          }

          FormRow({ label: '手机号', required: true }) {
            FormTextInput({ value: this.phone, placeholder: '请输入手机号', maxLength: 11, inputType: InputType.Number })
          }

          FormRow({ label: '密码', required: true }) {
            FormTextInput({ value: this.password, placeholder: '请输入密码（至少6位）', maxLength: 20, inputType: InputType.Password })
          }

          FormRow({ label: '确认密码', required: true }) {
            FormTextInput({ value: this.confirmPassword, placeholder: '请再次输入密码', maxLength: 20, inputType: InputType.Password })
          }

          FormRow({ label: '角色' }) {
            Row() {
              ForEach(
                [
                  { role: UserRole.PARENT, label: '家长' },
                  { role: UserRole.STUDENT, label: '学生' },
                  { role: UserRole.TEACHER, label: '教师' },
                ],
                (item: RoleOption) => {
                  Column() {
                    Text(item.label)
                      .fontSize(Constants.FONT_MD)
                      .fontColor(this.selectedRole === item.role ? Constants.COLOR_WHITE : Constants.COLOR_TEXT_PRIMARY)
                  }
                  .layoutWeight(1)
                  .height(36)
                  .backgroundColor(this.selectedRole === item.role ? Constants.COLOR_PRIMARY : Constants.COLOR_BG)
                  .borderRadius(Constants.BUTTON_RADIUS)
                  .justifyContent(FlexAlign.Center)
                  .margin({ right: Constants.SPACE_SM })
                  .onClick(() => { this.selectedRole = item.role; })
                }
              )
            }
            .width('100%')
          }

          Button('注册')
            .width('100%')
            .height(48)
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .margin({ top: Constants.SPACE_XXL, left: Constants.SPACE_LG, right: Constants.SPACE_LG })
            .onClick(() => { this.handleRegister(); })

          Row() {
            Text('已有账号？')
              .fontSize(Constants.FONT_MD)
              .fontColor(Constants.COLOR_TEXT_HINT)
            Text('去登录')
              .fontSize(Constants.FONT_MD)
              .fontColor(Constants.COLOR_PRIMARY)
              .onClick(() => { RouterUtil.toLogin(); })
          }
          .justifyContent(FlexAlign.Center)
          .margin({ top: Constants.SPACE_LG })
        }
        .width('100%')
        .padding({ top: Constants.SPACE_LG })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  handleRegister(): void {
    if (!this.name) {
      promptAction.showToast({ message: '请输入姓名' });
      return;
    }
    if (!this.phone) {
      promptAction.showToast({ message: '请输入手机号' });
      return;
    }
    if (this.password.length < 6) {
      promptAction.showToast({ message: '密码至少6位' });
      return;
    }
    if (this.password !== this.confirmPassword) {
      promptAction.showToast({ message: '两次密码不一致' });
      return;
    }
    promptAction.showToast({ message: '注册提交成功，请等待审核' });
    RouterUtil.toLogin();
  }
}
