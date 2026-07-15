import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { GradeService } from '../../services/GradeService';
import { GradeReport, SubjectGrade } from '../../models/GradeModel';
import { GradeCard } from '../../components/card/GradeCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { User } from '../../models/UserModel';
import { UserService } from '../../services/UserService';
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
  @State students: User[] = [];
  @State loading: boolean = true;
  @State studentId: string = '';
  @State showForm: boolean = false;
  @State submitting: boolean = false;
  @State formStudentId: string = '';
  @State formStudentName: string = '';
  @State formExamName: string = '';
  @State formExamDate: number = 0;
  @State formChineseScore: string = '';
  @State formChineseFullScore: string = '100';
  @State formMathScore: string = '';
  @State formMathFullScore: string = '100';
  @State formEnglishScore: string = '';
  @State formEnglishFullScore: string = '100';
  @State formTotalScore: string = '';
  @State formTotalFullScore: string = '';
  @State formClassRank: string = '';
  @State formGradeRank: string = '';
  @State formTeacherComment: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as GradeListParams;
    const id = (params && params.studentId) || this.userStore.getStudentId();
    this.studentId = id || '';
    await this.loadStudents();
    await this.loadData();
  }

  async loadStudents(): Promise<void> {
    if (!this.userStore.isTeacher() && !this.userStore.isLeader()) {
      this.students = [];
      return;
    }
    const res = await UserService.getStudents();
    this.students = res.code === 0 && res.data ? res.data : [];
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
  ScorePair(subject: string, scoreText: string, fullScoreText: string) {
    Row() {
      Column() {
        Text(subject)
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_SECONDARY)
          .width('100%')
        TextInput({ placeholder: '得分', text: scoreText })
          .width('100%')
          .height(40)
          .type(InputType.Number)
          .fontSize(Constants.FONT_MD)
          .backgroundColor(Constants.COLOR_SURFACE)
          .borderRadius(Constants.BUTTON_RADIUS)
          .border({ width: 0.5, color: Constants.COLOR_BORDER })
          .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
          .margin({ top: 4 })
          .onChange((v: string) => {
            if (subject === '语文') {
              this.formChineseScore = v;
            } else if (subject === '数学') {
              this.formMathScore = v;
            } else {
              this.formEnglishScore = v;
            }
          })
      }
      .layoutWeight(1)
      .margin({ right: Constants.SPACE_SM })

      Column() {
        Text('满分')
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_SECONDARY)
          .width('100%')
        TextInput({ placeholder: '满分', text: fullScoreText })
          .width('100%')
          .height(40)
          .type(InputType.Number)
          .fontSize(Constants.FONT_MD)
          .backgroundColor(Constants.COLOR_SURFACE)
          .borderRadius(Constants.BUTTON_RADIUS)
          .border({ width: 0.5, color: Constants.COLOR_BORDER })
          .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
          .margin({ top: 4 })
          .onChange((v: string) => {
            if (subject === '语文') {
              this.formChineseFullScore = v;
            } else if (subject === '数学') {
              this.formMathFullScore = v;
            } else {
              this.formEnglishFullScore = v;
            }
          })
      }
      .width(96)
    }
    .width('100%')
    .margin({ top: Constants.SPACE_SM })
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

      Text('学生姓名')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
      TextInput({ placeholder: '请输入学生姓名，支持唯一关键词匹配', text: this.formStudentName })
        .width('100%')
        .height(40)
        .fontSize(Constants.FONT_MD)
        .backgroundColor(Constants.COLOR_SURFACE)
        .borderRadius(Constants.BUTTON_RADIUS)
        .border({ width: 0.5, color: Constants.COLOR_BORDER })
        .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
        .margin({ top: 4, bottom: Constants.SPACE_SM })
        .onChange((v: string) => { this.formStudentName = v; })

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

      this.ScorePair('语文', this.formChineseScore, this.formChineseFullScore)
      this.ScorePair('数学', this.formMathScore, this.formMathFullScore)
      this.ScorePair('英语', this.formEnglishScore, this.formEnglishFullScore)

      Text('总分')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '留空时自动按各科合计', text: this.formTotalScore })
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

      Text('总满分')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
        .width('100%')
        .margin({ top: Constants.SPACE_SM })
      TextInput({ placeholder: '留空时自动按各科满分合计', text: this.formTotalFullScore })
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

      Row() {
        Column() {
          Text('班级排名')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_SECONDARY)
            .width('100%')
          TextInput({ placeholder: '班级排名', text: this.formClassRank })
            .width('100%')
            .height(40)
            .type(InputType.Number)
            .fontSize(Constants.FONT_MD)
            .backgroundColor(Constants.COLOR_SURFACE)
            .borderRadius(Constants.BUTTON_RADIUS)
            .border({ width: 0.5, color: Constants.COLOR_BORDER })
            .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
            .margin({ top: 4 })
            .onChange((v: string) => { this.formClassRank = v; })
        }
        .layoutWeight(1)
        .margin({ right: Constants.SPACE_SM })

        Column() {
          Text('年级排名')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_SECONDARY)
            .width('100%')
          TextInput({ placeholder: '年级排名', text: this.formGradeRank })
            .width('100%')
            .height(40)
            .type(InputType.Number)
            .fontSize(Constants.FONT_MD)
            .backgroundColor(Constants.COLOR_SURFACE)
            .borderRadius(Constants.BUTTON_RADIUS)
            .border({ width: 0.5, color: Constants.COLOR_BORDER })
            .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD })
            .margin({ top: 4 })
            .onChange((v: string) => { this.formGradeRank = v; })
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ top: Constants.SPACE_SM })

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
    this.formStudentName = this.resolveStudentName(this.studentId);
    this.formExamName = '';
    this.formExamDate = Date.now();
    this.formChineseScore = '';
    this.formChineseFullScore = '100';
    this.formMathScore = '';
    this.formMathFullScore = '100';
    this.formEnglishScore = '';
    this.formEnglishFullScore = '100';
    this.formTotalScore = '';
    this.formTotalFullScore = '';
    this.formClassRank = '';
    this.formGradeRank = '';
    this.formTeacherComment = '';
    this.showForm = true;
  }

  private resolveStudentName(studentId: string): string {
    if (!studentId) {
      return '';
    }
    const student = (this.students || []).find((item: User) => item.id === studentId);
    return student ? student.name : '';
  }

  private resolveStudent(): User | null {
    const keyword = this.formStudentName.trim();
    if (!keyword) {
      return null;
    }
    const students = this.students || [];
    let matched = students.filter((item: User) => item.name === keyword);
    if (matched.length === 1) {
      return matched[0];
    }
    matched = students.filter((item: User) => item.name.indexOf(keyword) >= 0);
    if (matched.length === 1) {
      return matched[0];
    }
    return null;
  }

  private toNumber(value: string): number {
    const num = Number(value);
    return Number.isNaN(num) ? 0 : num;
  }

  private addSubject(subjects: SubjectGrade[], name: string, scoreText: string, fullScoreText: string, classRank: number, gradeRank: number): void {
    if (!scoreText) {
      return;
    }
    const score = this.toNumber(scoreText);
    const fullScore = this.toNumber(fullScoreText);
    const item: SubjectGrade = {
      subject: name,
      score: score,
      fullScore: fullScore,
      classAverage: 0,
      gradeAverage: 0,
      classRank: classRank,
      gradeRank: gradeRank,
      trend: 'stable',
    };
    subjects.push(item);
  }

  async handleSubmit(): Promise<void> {
    const student = this.resolveStudent();
    if (!student || !this.formExamName) {
      promptAction.openToast({ message: '请填写考试名称，并输入唯一匹配的学生姓名' });
      return;
    }
    const classRank = this.toNumber(this.formClassRank);
    const gradeRank = this.toNumber(this.formGradeRank);
    const subjects: SubjectGrade[] = [];
    this.addSubject(subjects, '语文', this.formChineseScore, this.formChineseFullScore, classRank, gradeRank);
    this.addSubject(subjects, '数学', this.formMathScore, this.formMathFullScore, classRank, gradeRank);
    this.addSubject(subjects, '英语', this.formEnglishScore, this.formEnglishFullScore, classRank, gradeRank);
    if (subjects.length === 0 && !this.formTotalScore) {
      promptAction.openToast({ message: '请至少填写一科成绩或总分' });
      return;
    }
    let subjectTotal = 0;
    let subjectFullTotal = 0;
    for (const item of subjects) {
      subjectTotal += item.score;
      subjectFullTotal += item.fullScore;
    }
    const report: GradeReport = {
      id: `grade_${Date.now()}`,
      studentId: student.id,
      studentName: student.name,
      className: student.className || '',
      examName: this.formExamName,
      examDate: this.formExamDate,
      subjects: subjects,
      totalScore: this.formTotalScore ? this.toNumber(this.formTotalScore) : subjectTotal,
      totalFullScore: this.formTotalFullScore ? this.toNumber(this.formTotalFullScore) : subjectFullTotal,
      classRank: classRank,
      classSize: 0,
      gradeRank: gradeRank,
      gradeSize: 0,
      teacherComment: this.formTeacherComment,
    };
    this.submitting = true;
    const res = await GradeService.create(report);
    this.submitting = false;
    if (res.code === 0) {
      promptAction.openToast({ message: '录入成功' });
      this.showForm = false;
      await this.loadData();
    } else {
      promptAction.openToast({ message: res.message || '录入失败' });
    }
  }
}
