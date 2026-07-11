import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { HomeworkService } from '../../services/HomeworkService';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { Submission } from '../../models/HomeworkModel';
import { AppNavBar } from '../../components/common/AppNavBar';
import { FormRow } from '../../components/form/FormRow';
import { FormTextArea } from '../../components/form/FormTextArea';

interface SubmitHomeworkParams {
  homeworkId: string;
}

@Entry
@Component
struct SubmitHomeworkPage {
  @State content: string = '';
  @State loading: boolean = false;
  private homeworkId: string = '';

  aboutToAppear(): void {
    const params = router.getParams() as SubmitHomeworkParams;
    this.homeworkId = params.homeworkId;
  }

  build() {
    Column() {
      AppNavBar({ title: '提交作业' })
      Scroll() {
        Column() {
          FormRow({ label: '提交内容', required: true }) {
            FormTextArea({ value: this.content, placeholder: '请输入你的作业内容或说明', maxLength: 1000 })
          }

          Button(this.loading ? '提交中...' : '提交')
            .width('90%')
            .height(48)
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .margin({ top: Constants.SPACE_XXL })
            .enabled(!this.loading)
            .onClick(() => { this.handleSubmit(); })
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

  async handleSubmit(): Promise<void> {
    if (!this.content) { promptAction.showToast({ message: '请输入提交内容' }); return; }
    this.loading = true;
    const store = UserStore.getInstance();
    const sub: Submission = {
      id: `sub_${Date.now()}`,
      homeworkId: this.homeworkId,
      studentId: store.currentUser?.id || '',
      studentName: store.currentUser?.name || '',
      studentAvatar: '',
      content: this.content,
      attachments: [],
      submittedAt: Date.now(),
      status: 'submitted',
    };
    const res = await HomeworkService.submit(sub);
    this.loading = false;
    if (res.code === 0) {
      promptAction.showToast({ message: '提交成功' });
      RouterUtil.back();
    }
  }
}
