import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { HomeworkService } from '../../services/HomeworkService';
import { SchoolService } from '../../services/SchoolService';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { Homework } from '../../models/HomeworkModel';
import { ClassInfo } from '../../models/SchoolModel';
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
  @State classes: ClassInfo[] = [];
  @State selectedClassId: string = '';
  @State selectedClassName: string = '';
  @State loadingClasses: boolean = true;

  async aboutToAppear(): Promise<void> {
    const store = UserStore.getInstance();
    const schoolId = store.currentUser?.schoolId || '1';
    const res = await SchoolService.getClasses(schoolId);
    this.classes = res.code === 0 && res.data ? res.data : [];
    const myClassId = store.currentUser?.classId || '';
    if (myClassId) {
      this.selectedClassId = myClassId;
      this.selectedClassName = store.currentUser?.className || '';
    } else if (this.classes.length > 0) {
      this.selectedClassId = this.classes[0].id;
      this.selectedClassName = this.classes[0].name;
    }
    this.loadingClasses = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '布置作业' })
      Scroll() {
        Column() {
          FormRow({ label: '科目', required: true }) {
            FormTextInput({ value: $subject, placeholder: '例如：语文、数学、英语' })
          }
          FormRow({ label: '作业标题', required: true }) {
            FormTextInput({ value: $title, placeholder: '请输入作业标题', maxLength: 50 })
          }
          FormRow({ label: '作业内容', required: true }) {
            FormTextArea({ value: $content, placeholder: '请输入作业内容和要求', maxLength: 1000 })
          }
          FormRow({ label: '布置班级', required: true }) {
            this.ClassChips()
          }
          FormRow({ label: '截止日期' }) {
            FormDatePicker({ timestamp: $dueDate, placeholder: '请选择截止日期' })
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
            .onClick(() => {
              this.handleAssign();
            })
        }
        .width('100%')
        .padding({ top: Constants.SPACE_LG })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  ClassChips() {
    if (this.loadingClasses) {
      Text('加载班级中...')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
    } else if ((this.classes || []).length === 0) {
      Text('暂无可选班级')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
    } else {
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.classes, (item: ClassInfo) => {
          Text(item.name)
            .fontSize(Constants.FONT_SM)
            .fontColor(this.selectedClassId === item.id ? Constants.COLOR_WHITE : Constants.COLOR_PRIMARY)
            .backgroundColor(this.selectedClassId === item.id ? Constants.COLOR_PRIMARY : Constants.COLOR_PRIMARY_SOFT)
            .borderRadius(14)
            .height(30)
            .padding({ left: 12, right: 12 })
            .margin({ right: 8, bottom: 8 })
            .onClick(() => {
              this.selectedClassId = item.id;
              this.selectedClassName = item.name;
            })
        }, (item: ClassInfo) => item.id)
      }
      .width('100%')
    }
  }

  async handleAssign(): Promise<void> {
    if (!this.subject) {
      promptAction.openToast({ message: '请输入科目' });
      return;
    }
    if (!this.title) {
      promptAction.openToast({ message: '请输入标题' });
      return;
    }
    if (!this.content) {
      promptAction.openToast({ message: '请输入内容' });
      return;
    }
    if (!this.selectedClassId) {
      promptAction.openToast({ message: '请选择布置班级' });
      return;
    }

    this.loading = true;
    const store = UserStore.getInstance();
    const hw: Homework = {
      id: `hw_${Date.now()}`,
      subject: this.subject,
      title: this.title,
      content: this.content,
      teacherId: store.currentUser?.id || '',
      teacherName: store.currentUser?.name || '',
      classId: this.selectedClassId,
      className: this.selectedClassName,
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
      promptAction.openToast({ message: '作业发布成功' });
      RouterUtil.back();
    } else {
      promptAction.openToast({ message: res.message || '发布失败' });
    }
  }
}
