import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { GradeService } from '../../services/GradeService';
import { GradeReport } from '../../models/GradeModel';
import { GradeCard } from '../../components/card/GradeCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';
import { FormDatePicker } from '../../components/form/FormDatePicker';

interface GradeListParams {
  studentId?: string;
}

@Entry
@Component
struct GradeListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State reports: GradeReport[] = [];
  @State loading: boolean = true;
  @State studentId: string = '';
  @State showForm: boolean = false;
  @State submitting: boolean = false;
  @State formStudentId: string = '';
  @State formExamName: string = '';
  @State formExamDate: number = 0;
  @State formTotalScore: string = '';
  @State formTotalFullScore: string = '';
  @State formClassRank: string = '';
  @State formTeacherComment: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as GradeListParams;
    const id = (params && params.studentId) || this.userStore.getStudentId() || this.userStore.currentUser?.id;
    if (id) {
      this.studentId = id;
    }
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;
    const res = await GradeService.getReports(this.studentId || undefined);
    this.reports = res.code === 0 && res.data ? res.data : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '学生成绩' }) {
        if (this.userStore.isTeacher()) {
          Button('+ 录入')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .height(32)
            .onClick(() => { this.showGradeForm(); })
        }
      }

      if (this.showForm) {
        this.GradeForm()
      }

      if (this.loading) {
        LoadingView()
      } else if ((this.reports || []).length === 0) {
        EmptyView({ message: '暂无成绩记录' })
      } else {
        List() {
          ForEach(this.reports || [], (report: GradeReport) => {
            ListItem() {
              GradeCard({ report: report, onTap: () => { RouterUtil.toGradeDetail(report.id); } })
            }
          }, (report: GradeReport) => report.id)
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
  GradeForm() {
    Column() {
      Text('录入成绩')
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: Constants.SPACE_SM })

      Text('学生ID')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextInput({ placeholder: '请输入学生ID', text: this.formStudentId })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formStudentId = this.normalizeStudentId(v); })

      Text('考试名称')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextInput({ placeholder: '请输入考试名称', text: this.formExamName })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formExamName = v; })

      Text('考试日期')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      FormDatePicker({ timestamp: $formExamDate, placeholder: '选择考试日期', allowPast: true, allowFuture: false })

      Text('总分')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '请输入总分', text: this.formTotalScore })
        .width('100%')
        .height(40)
        .type(InputType.Number)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formTotalScore = v; })

      Text('满分')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '请输入满分', text: this.formTotalFullScore })
        .width('100%')
        .height(40)
        .type(InputType.Number)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formTotalFullScore = v; })

      Text('班级排名')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '请输入班级排名', text: this.formClassRank })
        .width('100%')
        .height(40)
        .type(InputType.Number)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formClassRank = v; })

      Text('教师评语')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextArea({ placeholder: '请输入教师评语', text: this.formTeacherComment })
        .width('100%')
        .height(80)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding(Constants.SPACE_MD)
        .margin({ top: 4 })
        .onChange((v: string) => { this.formTeacherComment = v; })

      Row() {
        Button('取消')
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_TEXT_SECONDARY)
          .backgroundColor(Constants.COLOR_BG)
          .borderRadius(Constants.BUTTON_RADIUS)
          .margin({ right: Constants.SPACE_SM })
          .onClick(() => { this.showForm = false; })
        Button(this.submitting ? '保存中...' : '保存')
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .enabled(!this.submitting)
          .onClick(() => { this.handleSubmit(); })
      }
      .width('100%')
      .margin({ top: Constants.SPACE_MD })
    }
    .width('100%')
    .padding(Constants.SPACE_LG)
    .backgroundColor(Constants.COLOR_WHITE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 1, color: Constants.COLOR_BORDER })
    .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM })
  }

  showGradeForm(): void {
    this.formStudentId = this.studentId;
    this.formExamName = '';
    this.formExamDate = Date.now();
    this.formTotalScore = '';
    this.formTotalFullScore = '';
    this.formClassRank = '';
    this.formTeacherComment = '';
    this.showForm = true;
  }

  private normalizeStudentId(value: string): string {
    let result = '';
    for (let i = 0; i < value.length && result.length < 18; i++) {
      const ch = value.charAt(i);
      if (ch >= '0' && ch <= '9') {
        result += ch;
      }
    }
    return result;
  }

  async handleSubmit(): Promise<void> {
    if (!this.formStudentId || !this.formExamName) {
      promptAction.openToast({ message: '请填写学生ID和考试名称' });
      return;
    }
    const totalScore = Number(this.formTotalScore);
    const totalFullScore = Number(this.formTotalFullScore);
    const classRank = Number(this.formClassRank);
    const report: GradeReport = {
      id: `grade_${Date.now()}`,
      studentId: this.formStudentId,
      studentName: '',
      className: '',
      examName: this.formExamName,
      examDate: this.formExamDate,
      subjects: [],
      totalScore: Number.isNaN(totalScore) ? 0 : totalScore,
      totalFullScore: Number.isNaN(totalFullScore) ? 0 : totalFullScore,
      classRank: Number.isNaN(classRank) ? 0 : classRank,
      classSize: 0,
      gradeRank: 0,
      gradeSize: 0,
      teacherComment: this.formTeacherComment,
    };
    this.submitting = true;
    const res = await GradeService.create(report);
    this.submitting = false;
    if (res.code === 0) {
      promptAction.openToast({ message: '录入成功' });
      this.showForm = false;
      this.studentId = this.formStudentId;
      await this.loadData();
    } else {
      promptAction.openToast({ message: res.message || '录入失败' });
    }
  }
}
