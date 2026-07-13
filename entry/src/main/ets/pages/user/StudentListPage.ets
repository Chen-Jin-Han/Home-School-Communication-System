import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { User } from '../../models/UserModel';
import { UserService } from '../../services/UserService';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

interface StudentListParams {
  classId?: string;
}

@Entry
@Component
struct StudentListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State students: User[] = [];
  @State loading: boolean = true;
  private classId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as StudentListParams;
    this.classId = params.classId || this.userStore.currentUser?.classId || '';
    await this.loadStudents();
  }

  async loadStudents(): Promise<void> {
    this.loading = true;
    if (!this.classId) {
      this.students = [];
      this.loading = false;
      return;
    }
    const res = await UserService.getClassStudents(this.classId);
    this.students = res.code === 0 ? (res.data || []).filter((item: User) => item.role === 'student') : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: this.userStore.currentUser?.className || '学生名单' })

      if (this.loading) {
        LoadingView()
      } else if ((this.students || []).length === 0) {
        EmptyView({ message: '暂无学生' })
      } else {
        List() {
          ForEach(this.students || [], (student: User) => {
            ListItem() {
              this.StudentRow(student)
            }
          })
        }
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: Constants.COLOR_DIVIDER })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  StudentRow(student: User) {
    Row() {
      Column() {
        Text((student.name || '?').charAt(0))
          .fontSize(18)
          .fontColor(Constants.COLOR_WHITE)
          .fontWeight(FontWeight.Bold)
      }
      .width(42)
      .height(42)
      .borderRadius(21)
      .backgroundColor(Constants.COLOR_INFO)
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(student.name)
          .fontSize(Constants.FONT_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
        Text(student.className || '未分班')
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 3 })
      }
      .margin({ left: Constants.SPACE_MD })
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('详情')
        .fontSize(Constants.FONT_SM)
        .fontColor(Constants.COLOR_TEXT_HINT)
    }
    .width('100%')
    .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })
    .backgroundColor(Constants.COLOR_WHITE)
    .onClick(() => {
      RouterUtil.toEvaluationList(student.id);
    })
  }
}
