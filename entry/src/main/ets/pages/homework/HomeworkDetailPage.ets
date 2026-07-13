import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { HomeworkService } from '../../services/HomeworkService';
import { Homework, Submission } from '../../models/HomeworkModel';
import { DateUtil } from '../../utils/DateUtil';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserRole } from '../../models/UserModel';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { ElementIcon } from '../../components/common/ElementIcon';

interface HomeworkDetailParams {
  homeworkId: string;
}

@Entry
@Component
struct HomeworkDetailPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State homework: Homework | null = null;
  @State submission: Submission | null = null;
  @State submissions: Submission[] = [];
  @State loading: boolean = true;
  @State showEditForm: boolean = false;
  @State editSubject: string = '';
  @State editTitle: string = '';
  @State editContent: string = '';
  @State editDueDate: number = 0;
  @State gradingSubmissionId: string = '';
  @State gradeScore: string = '';
  @State gradeComment: string = '';
  private homeworkId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as HomeworkDetailParams;
    if (!params || !params.homeworkId) {
      router.back();
      this.loading = false;
      return;
    }
    this.homeworkId = params.homeworkId;
    const res = await HomeworkService.getDetail(this.homeworkId);
    this.homework = res.data || null;

    if (this.userStore.isStudent()) {
      const sr = await HomeworkService.getSubmission(this.homeworkId, this.userStore.currentUser!.id);
      this.submission = sr.data || null;
    } else if (this.userStore.isTeacher()) {
      await this.loadSubmissions();
    }
    this.loading = false;
  }

  async loadSubmissions(): Promise<void> {
    const res = await HomeworkService.getSubmissions(this.homeworkId);
    this.submissions = res.code === 0 && res.data ? res.data : [];
  }

  build() {
    Column() {
      AppNavBar({ title: '作业详情' })
      if (this.loading) {
        LoadingView()
      } else if (this.homework) {
        Scroll() {
          Column() {
            Text(this.homework.title)
              .fontSize(Constants.FONT_XXL)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .width('100%')

            Row() {
              Text(this.homework.subject).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_PRIMARY)
              Text(`  ${this.homework.teacherName}`).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_HINT)
              Blank()
              Text(`截止 ${DateUtil.formatDate(this.homework.dueDate)}`).fontSize(Constants.FONT_SM).fontColor(this.homework.status === 'expired' ? Constants.COLOR_DANGER : Constants.COLOR_WARNING)
            }
            .width('100%')
            .margin({ top: Constants.SPACE_SM })

            Divider().margin({ top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })

            Text(this.homework.content)
              .fontSize(Constants.FONT_LG)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .lineHeight(26)
              .width('100%')

            Blank().height(Constants.SPACE_XL)

            if (this.submission) {
              Column() {
                Text('我的提交').fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).width('100%')
                Text(this.submission.content).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_SECONDARY).margin({ top: Constants.SPACE_SM })
                if (this.submission.status === 'graded') {
                  Text(`得分: ${this.submission.score}分`).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_PRIMARY).margin({ top: Constants.SPACE_SM })
                  if (this.submission.teacherComment) {
                    Text(`评语: ${this.submission.teacherComment}`).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_SECONDARY).margin({ top: 4 })
                  }
                }
              }
              .width('100%')
              .padding(Constants.SPACE_LG)
              .backgroundColor(Constants.COLOR_DIVIDER)
              .borderRadius(Constants.CARD_RADIUS)
            }

            // Submit button for students
            if (this.userStore.isStudent() && !this.submission && this.homework.status === 'active') {
              Blank().height(Constants.SPACE_XXL)
              Button('提交作业')
                .width('100%')
                .height(44)
                .fontColor(Constants.COLOR_WHITE)
                .backgroundColor(Constants.COLOR_PRIMARY)
                .borderRadius(Constants.BUTTON_RADIUS)
                .onClick(() => { RouterUtil.toSubmitHomework(this.homeworkId); })
            }

            // Teacher management section
            if (this.userStore.isTeacher()) {
              Blank().height(Constants.SPACE_LG)
              Row() {
                Button('编辑')
                  .layoutWeight(1)
                  .height(40)
                  .fontSize(Constants.FONT_MD)
                  .fontColor(Constants.COLOR_PRIMARY)
                  .backgroundColor(Constants.COLOR_PRIMARY_SOFT)
                  .borderRadius(Constants.BUTTON_RADIUS)
                  .margin({ right: Constants.SPACE_SM })
                  .onClick(() => { this.startEdit(); })
                Button('删除')
                  .layoutWeight(1)
                  .height(40)
                  .fontSize(Constants.FONT_MD)
                  .fontColor(Constants.COLOR_WHITE)
                  .backgroundColor(Constants.COLOR_DANGER)
                  .borderRadius(Constants.BUTTON_RADIUS)
                  .onClick(() => { this.handleDelete(); })
              }
              .width('100%')

              if (this.showEditForm) {
                this.EditForm()
              }

              Blank().height(Constants.SPACE_LG)
              Text('学生提交')
                .fontSize(Constants.FONT_LG)
                .fontWeight(FontWeight.Bold)
                .fontColor(Constants.COLOR_TEXT_PRIMARY)
                .width('100%')

              if ((this.submissions || []).length === 0) {
                Text('暂无学生提交')
                  .fontSize(Constants.FONT_MD)
                  .fontColor(Constants.COLOR_TEXT_HINT)
                  .margin({ top: Constants.SPACE_SM })
                  .width('100%')
              } else {
                ForEach(this.submissions || [], (sub: Submission) => {
                  this.SubmissionItem(sub)
                }, (sub: Submission) => sub.id)
              }
            }
          }
          .width('100%')
          .padding(Constants.SPACE_LG)
          .backgroundColor(Constants.COLOR_WHITE)
          .borderRadius(Constants.CARD_RADIUS)
          .border({ width: 1, color: Constants.COLOR_BORDER })
          .margin(Constants.SPACE_LG)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  EditForm() {
    Column() {
      Text('编辑作业')
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: Constants.SPACE_SM })

      Text('科目')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextInput({ placeholder: '科目', text: this.editSubject })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.editSubject = v; })

      Text('标题')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextInput({ placeholder: '标题', text: this.editTitle })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.editTitle = v; })

      Text('内容')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextArea({ placeholder: '内容', text: this.editContent })
        .width('100%')
        .height(100)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding(Constants.SPACE_MD)
        .margin({ top: 4 })
        .onChange((v: string) => { this.editContent = v; })

      Text('截止日期')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      Row() {
        Text(this.editDueDate > 0 ? DateUtil.formatDate(this.editDueDate) : '选择日期')
          .fontSize(Constants.FONT_MD)
          .fontColor(this.editDueDate > 0 ? Constants.COLOR_TEXT_PRIMARY : Constants.COLOR_TEXT_HINT)
          .layoutWeight(1)
        ElementIcon({ name: 'Calendar', iconSize: 18, color: Constants.COLOR_TEXT_HINT })
      }
      .width('100%')
      .height(40)
      .backgroundColor(Constants.COLOR_SURFACE)
      .borderRadius(Constants.BUTTON_RADIUS)
      .border({ width: 0.5, color: Constants.COLOR_BORDER })
      .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
      .margin({ top: 4 })
      .onClick(() => {
        DatePickerDialog.show({
          start: new Date('2020-01-01'),
          end: new Date('2035-12-31'),
          selected: this.editDueDate ? new Date(this.editDueDate) : new Date(),
          onAccept: (value: DatePickerResult) => {
            const d = new Date(value.year, value.month, value.day);
            this.editDueDate = d.getTime();
          }
        });
      })

      Row() {
        Button('取消')
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_TEXT_SECONDARY)
          .backgroundColor(Constants.COLOR_BG)
          .borderRadius(Constants.BUTTON_RADIUS)
          .margin({ right: Constants.SPACE_SM })
          .onClick(() => { this.showEditForm = false; })
        Button('保存')
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .onClick(() => { this.handleSaveEdit(); })
      }
      .width('100%')
      .margin({ top: Constants.SPACE_MD })
    }
    .width('100%')
    .padding(Constants.SPACE_MD)
    .backgroundColor(Constants.COLOR_DIVIDER)
    .borderRadius(Constants.CARD_RADIUS)
    .margin({ top: Constants.SPACE_SM })
  }

  @Builder
  SubmissionItem(sub: Submission) {
    Column() {
      Row() {
        Text(sub.studentName)
          .fontSize(Constants.FONT_MD)
          .fontWeight(FontWeight.Medium)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
          .layoutWeight(1)
        Text(this.submissionStatusLabel(sub.status))
          .fontSize(Constants.FONT_SM)
          .fontColor(this.submissionStatusColor(sub.status))
      }
      .width('100%')

      Text(sub.content)
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .margin({ top: 4 })
        .width('100%')

      if (sub.status === 'graded' && sub.score !== undefined) {
        Text(`得分: ${sub.score}分`)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_PRIMARY)
          .margin({ top: 4 })
      }

      if (this.gradingSubmissionId === sub.id) {
        TextInput({ placeholder: '分数(0-100)', text: this.gradeScore })
          .width('100%')
          .height(40)
          .type(InputType.Number)
          .fontSize(Constants.FONT_MD)
          .backgroundColor(Constants.COLOR_WHITE)
          .borderRadius(Constants.BUTTON_RADIUS)
          .border({ width: 0.5, color: Constants.COLOR_BORDER })
          .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
          .margin({ top: Constants.SPACE_SM })
          .onChange((v: string) => { this.gradeScore = v; })

        TextInput({ placeholder: '评语', text: this.gradeComment })
          .width('100%')
          .height(40)
          .fontSize(Constants.FONT_MD)
          .backgroundColor(Constants.COLOR_WHITE)
          .borderRadius(Constants.BUTTON_RADIUS)
          .border({ width: 0.5, color: Constants.COLOR_BORDER })
          .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
          .margin({ top: Constants.SPACE_SM })
          .onChange((v: string) => { this.gradeComment = v; })

        Row() {
          Button('取消')
            .layoutWeight(1)
            .height(36)
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_SECONDARY)
            .backgroundColor(Constants.COLOR_BG)
            .borderRadius(Constants.BUTTON_RADIUS)
            .margin({ right: Constants.SPACE_SM })
            .onClick(() => { this.gradingSubmissionId = ''; })
          Button('提交评分')
            .layoutWeight(1)
            .height(36)
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .onClick(() => { this.handleGrade(sub); })
        }
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      } else {
        Button('批改')
          .height(32)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .margin({ top: Constants.SPACE_SM })
          .onClick(() => { this.startGrade(sub); })
      }
    }
    .width('100%')
    .padding(Constants.SPACE_MD)
    .backgroundColor(Constants.COLOR_DIVIDER)
    .borderRadius(Constants.CARD_RADIUS)
    .margin({ top: Constants.SPACE_SM })
  }

  submissionStatusLabel(status: string): string {
    if (status === 'graded') {
      return '已批改';
    }
    if (status === 'submitted') {
      return '待批改';
    }
    return '未提交';
  }

  submissionStatusColor(status: string): string {
    if (status === 'graded') {
      return Constants.COLOR_SUCCESS;
    }
    if (status === 'submitted') {
      return Constants.COLOR_WARNING;
    }
    return Constants.COLOR_TEXT_HINT;
  }

  startEdit(): void {
    const current = this.homework;
    if (!current) {
      return;
    }
    this.editSubject = current.subject;
    this.editTitle = current.title;
    this.editContent = current.content;
    this.editDueDate = current.dueDate;
    this.showEditForm = true;
  }

  async handleSaveEdit(): Promise<void> {
    const current = this.homework;
    if (!current) {
      return;
    }
    if (!this.editSubject || !this.editTitle || !this.editContent) {
      promptAction.openToast({ message: '请填写完整' });
      return;
    }
    const hw: Homework = {
      id: current.id,
      subject: this.editSubject,
      title: this.editTitle,
      content: this.editContent,
      teacherId: current.teacherId,
      teacherName: current.teacherName,
      classId: current.classId,
      className: current.className,
      attachments: current.attachments,
      dueDate: this.editDueDate,
      assignedAt: current.assignedAt,
      submissionCount: current.submissionCount,
      totalStudents: current.totalStudents,
      status: current.status,
    };
    const res = await HomeworkService.update(hw);
    if (res.code === 0) {
      this.homework = hw;
      this.showEditForm = false;
      promptAction.openToast({ message: '修改成功' });
    } else {
      promptAction.openToast({ message: res.message || '修改失败' });
    }
  }

  async handleDelete(): Promise<void> {
    const res = await HomeworkService.delete(this.homeworkId);
    if (res.code === 0) {
      promptAction.openToast({ message: '已删除' });
      router.back();
    } else {
      promptAction.openToast({ message: res.message || '删除失败' });
    }
  }

  startGrade(sub: Submission): void {
    this.gradingSubmissionId = sub.id;
    this.gradeScore = sub.score !== undefined ? sub.score.toString() : '';
    this.gradeComment = sub.teacherComment || '';
  }

  async handleGrade(sub: Submission): Promise<void> {
    const scoreNum = Number(this.gradeScore);
    if (Number.isNaN(scoreNum)) {
      promptAction.openToast({ message: '请输入有效分数' });
      return;
    }
    const res = await HomeworkService.grade(sub.id, scoreNum, this.gradeComment);
    if (res.code === 0) {
      promptAction.openToast({ message: '批改成功' });
      this.gradingSubmissionId = '';
      await this.loadSubmissions();
    } else {
      promptAction.openToast({ message: res.message || '批改失败' });
    }
  }
}
