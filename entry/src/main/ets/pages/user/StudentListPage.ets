import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { User } from '../../models/UserModel';
import { UserService } from '../../services/UserService';
import { UserStore } from '../../store/UserStore';
import { ChatService } from '../../services/ChatService';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { SearchBar } from '../../components/common/SearchBar';
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
  @State @Watch('onKeywordChange') searchKeyword: string = '';
  @State filteredList: User[] = [];
  @State loading: boolean = true;
  private classId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as StudentListParams;
    this.classId = params.classId || this.userStore.currentUser?.classId || '';
    await this.loadStudents();
  }

  async loadStudents(): Promise<void> {
    this.loading = true;
    const res = await UserService.getStudents(this.classId || undefined);
    this.students = res.code === 0 ? (res.data || []).filter((item: User) => item.role === 'student') : [];
    this.filteredList = this.computeFiltered();
    this.loading = false;
  }

  private onKeywordChange(): void {
    this.filteredList = this.computeFiltered();
  }

  private computeFiltered(): User[] {
    const keyword = this.searchKeyword.trim();
    if (!keyword) {
      return this.students || [];
    }
    return (this.students || []).filter((item: User) => item.name.includes(keyword));
  }

  build() {
    Column() {
      AppNavBar({ title: this.userStore.currentUser?.className || '学生名单' })

      SearchBar({ value: $searchKeyword, placeholder: '搜索学生姓名...' })

      if (this.loading) {
        LoadingView()
      } else if ((this.filteredList || []).length === 0) {
        EmptyView({ message: this.searchKeyword.trim() ? '没有匹配的学生' : '暂无学生' })
      } else {
        List() {
          ForEach(this.filteredList || [], (student: User) => {
            ListItem() {
              this.StudentRow(student)
            }
          }, (student: User) => student.id)
        }
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: Constants.COLOR_DIVIDER })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  StudentRow(student: User) {
    Row() {
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
          if (student.phone && student.phone.length > 0) {
            Text(student.phone)
              .fontSize(Constants.FONT_SM)
              .fontColor(Constants.COLOR_TEXT_HINT)
              .margin({ top: 2 })
          }
        }
        .margin({ left: Constants.SPACE_MD })
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .layoutWeight(1)
      .onClick(() => {
        RouterUtil.toEvaluationList(student.id);
      })

      Column() {
        if (this.userStore.isTeacher()) {
          Text('发消息')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_PRIMARY)
            .padding({ left: Constants.SPACE_SM, right: Constants.SPACE_SM, top: 6, bottom: 6 })
            .backgroundColor(Constants.COLOR_PRIMARY_SOFT)
            .borderRadius(Constants.BUTTON_RADIUS)
            .margin({ bottom: Constants.SPACE_SM })
            .onClick(() => { this.startConversation(student); })
          Text('写评价')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_PRIMARY)
            .padding({ left: Constants.SPACE_SM, right: Constants.SPACE_SM, top: 6, bottom: 6 })
            .backgroundColor(Constants.COLOR_PRIMARY_SOFT)
            .borderRadius(Constants.BUTTON_RADIUS)
            .margin({ bottom: Constants.SPACE_SM })
            .onClick(() => {
              RouterUtil.toWriteEvaluation(student.id, student.name);
            })
        }
        Text('详情')
          .fontSize(Constants.FONT_SM)
          .fontColor(Constants.COLOR_TEXT_SECONDARY)
          .padding({ left: Constants.SPACE_SM, right: Constants.SPACE_SM, top: 6, bottom: 6 })
          .backgroundColor(Constants.COLOR_BG)
          .borderRadius(Constants.BUTTON_RADIUS)
          .onClick(() => {
            RouterUtil.toGradeList(student.id);
          })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })
    .backgroundColor(Constants.COLOR_WHITE)
  }

  async startConversation(student: User): Promise<void> {
    const res = await ChatService.createPrivateConversation(student.id);
    const conv = res.code === 0 ? res.data : null;
    if (conv) {
      RouterUtil.toChat(conv.id, student.name);
    } else {
      promptAction.openToast({ message: res.message || '创建会话失败' });
    }
  }
}
