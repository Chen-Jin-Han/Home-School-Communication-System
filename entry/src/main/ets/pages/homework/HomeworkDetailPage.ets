import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { HomeworkService } from '../../services/HomeworkService';
import { Homework, Submission } from '../../models/HomeworkModel';
import { DateUtil } from '../../utils/DateUtil';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserRole } from '../../models/UserModel';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';

interface HomeworkDetailParams {
  homeworkId: string;
}

@Entry
@Component
struct HomeworkDetailPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State homework: Homework | null = null;
  @State submission: Submission | null = null;
  @State loading: boolean = true;
  private homeworkId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as HomeworkDetailParams;
    this.homeworkId = params.homeworkId;
    const res = await HomeworkService.getDetail(this.homeworkId);
    this.homework = res.data || null;

    if (this.userStore.isStudent()) {
      const sr = await HomeworkService.getSubmission(this.homeworkId, this.userStore.currentUser!.id);
      this.submission = sr.data || null;
    }
    this.loading = false;
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
          }
          .width('100%')
          .padding(Constants.SPACE_LG)
          .backgroundColor(Constants.COLOR_WHITE)
          .borderRadius(Constants.CARD_RADIUS)
          .border({ width: 1, color: Constants.COLOR_BORDER })
          .margin(Constants.SPACE_LG)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }
}
