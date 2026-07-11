import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { HomeworkService } from '../../services/HomeworkService';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { Homework } from '../../models/HomeworkModel';
import { AppNavBar } from '../../components/common/AppNavBar';
import { FormRow } from '../../components/form/FormRow';
import { FormTextInput } from '../../components/form/FormTextInput';
import { FormTextArea } from '../../components/form/FormTextArea';
import { FormDatePicker } from '../../components/form/FormDatePicker';

@Entry
@Component
struct AssignHomeworkPage {
  @State subject: string = '';
  @State title: string = '';
  @State content: string = '';
  @State dueDate: number = Date.now() + 86400000 * 2;
  @State loading: boolean = false;

  build() {
    Column() {
      AppNavBar({ title: '布置作业' })
      Scroll() {
        Column() {
          FormRow({ label: '科目', required: true }) {
            FormTextInput({ value: this.subject, placeholder: '例如：语文、数学、英语' })
          }
          FormRow({ label: '作业标题', required: true }) {
            FormTextInput({ value: this.title, placeholder: '请输入作业标题', maxLength: 50 })
          }
          FormRow({ label: '作业内容', required: true }) {
            FormTextArea({ value: this.content, placeholder: '请输入作业内容和要求', maxLength: 1000 })
          }
          FormRow({ label: '截止日期' }) {
            FormDatePicker({ timestamp: this.dueDate, placeholder: '请选择截止日期' })
          }

          Button(this.loading ? '发布中...' : '发布作业')
            .width('90%')
            .height(48)
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .margin({ top: Constants.SPACE_XXL })
            .enabled(!this.loading)
            .onClick(() => { this.handleAssign(); })
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

  async handleAssign(): Promise<void> {
    if (!this.subject) { promptAction.showToast({ message: '请输入科目' }); return; }
    if (!this.title) { promptAction.showToast({ message: '请输入标题' }); return; }
    if (!this.content) { promptAction.showToast({ message: '请输入内容' }); return; }
    this.loading = true;
    const store = UserStore.getInstance();
    const hw: Homework = {
      id: `hw_${Date.now()}`,
      subject: this.subject,
      title: this.title,
      content: this.content,
      teacherId: store.currentUser?.id || '',
      teacherName: store.currentUser?.name || '',
      classId: store.currentUser?.classId || '',
      className: store.currentUser?.className || '',
      attachments: [],
      dueDate: this.dueDate,
      assignedAt: Date.now(),
      submissionCount: 0,
      totalStudents: 40,
      status: 'active',
    };
    const res = await HomeworkService.create(hw);
    this.loading = false;
    if (res.code === 0) {
      promptAction.showToast({ message: '作业发布成功' });
      RouterUtil.back();
    }
  }
}
