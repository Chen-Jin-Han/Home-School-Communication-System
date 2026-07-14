import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { EvaluationService } from '../../services/EvaluationService';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { Evaluation, EvaluationPeriod } from '../../models/EvaluationModel';
import { AppNavBar } from '../../components/common/AppNavBar';
import { FormRow } from '../../components/form/FormRow';
import { FormStarRating } from '../../components/form/FormStarRating';
import { FormTextArea } from '../../components/form/FormTextArea';

interface EvalTypeOption {
  value: string;
  label: string;
}

interface WriteEvaluationParams {
  studentId: string;
  studentName?: string;
  studentAvatar?: string;
}

@Entry
@Component
struct WriteEvaluationPage {
  @State rating: number = 0;
  @State content: string = '';
  @State evaluationType: string = 'daily';
  @State loading: boolean = false;
  private studentId: string = '';
  private studentName: string = '';
  private studentAvatar: string = '';

  aboutToAppear(): void {
    const params = router.getParams() as WriteEvaluationParams;
    if (!params || !params.studentId) {
      router.back();
      return;
    }
    this.studentId = params.studentId;
    this.studentName = params.studentName || '';
    this.studentAvatar = params.studentAvatar || '';
  }

  build() {
    Column() {
      AppNavBar({ title: '写评价' })
      Scroll() {
        Column() {
          FormRow({ label: '评价类型' }) {
            Row() {
              ForEach(
                [
                  { value: 'daily', label: '日常' } as EvalTypeOption,
                  { value: 'weekly', label: '每周' } as EvalTypeOption,
                  { value: 'monthly', label: '每月' } as EvalTypeOption,
                  { value: 'semester', label: '学期' } as EvalTypeOption,
                ] as EvalTypeOption[],
                (item: EvalTypeOption) => {
                  Column() {
                    Text(item.label)
                      .fontSize(Constants.FONT_SM)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(this.evaluationType === item.value ? Constants.COLOR_WHITE : Constants.COLOR_TEXT_PRIMARY)
                  }
                  .layoutWeight(1)
                  .height(34)
                  .backgroundColor(this.evaluationType === item.value ? Constants.COLOR_PRIMARY : Constants.COLOR_SURFACE)
                  .border({
                    width: 1,
                    color: this.evaluationType === item.value ? Constants.COLOR_PRIMARY : Constants.COLOR_BORDER,
                  })
                  .borderRadius(Constants.BUTTON_RADIUS)
                  .justifyContent(FlexAlign.Center)
                  .margin({ right: Constants.SPACE_XS })
                  .onClick(() => {
                    this.evaluationType = item.value;
                  })
                }
              )
            }
            .width('100%')
          }

          FormRow({ label: '评分' }) {
            FormStarRating({ rating: $rating })
          }
          FormRow({ label: '评价内容', required: true }) {
            FormTextArea({ value: $content, placeholder: '请输入对学生的评价...', maxLength: 500 })
          }

          Button(this.loading ? '提交中...' : '提交评价')
            .width('90%')
            .height(48)
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .margin({ top: Constants.SPACE_XXL })
            .enabled(!this.loading)
            .onClick(() => {
              this.handleSubmit();
            })
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
    if (this.rating === 0) {
      promptAction.openToast({ message: '请评分' });
      return;
    }
    if (!this.content) {
      promptAction.openToast({ message: '请输入评价内容' });
      return;
    }

    this.loading = true;
    const store = UserStore.getInstance();
    const ev: Evaluation = {
      id: `ev_${Date.now()}`,
      studentId: this.studentId,
      studentName: this.studentName,
      studentAvatar: this.studentAvatar,
      teacherId: store.currentUser?.id || '',
      teacherName: store.currentUser?.name || '',
      teacherAvatar: store.currentUser?.avatar || '',
      type: this.evaluationType as EvaluationPeriod,
      periodLabel: new Date().toISOString().substring(0, 10),
      rating: this.rating,
      tags: [],
      content: this.content,
      createdAt: Date.now(),
      updatedAt: Date.now(),
    };
    const res = await EvaluationService.create(ev);
    this.loading = false;
    if (res.code === 0) {
      promptAction.openToast({ message: '评价提交成功' });
      RouterUtil.back();
    } else {
      promptAction.openToast({ message: res.message || '提交失败' });
    }
  }
}
