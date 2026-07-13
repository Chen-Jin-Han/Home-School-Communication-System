import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { ActivityService } from '../../services/ActivityService';
import { Activity, ActivityComment } from '../../models/ActivityModel';
import { DateUtil } from '../../utils/DateUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

interface ActivityDetailParams {
  activityId: string;
}

@Entry
@Component
struct ActivityDetailPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State activity: Activity | null = null;
  @State comments: ActivityComment[] = [];
  @State commentInput: string = '';
  @State loading: boolean = true;
  @State sending: boolean = false;
  private activityId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as ActivityDetailParams;
    if (!params || !params.activityId) {
      router.back();
      return;
    }
    this.activityId = params.activityId;
    const results = await Promise.all([
      ActivityService.getDetail(this.activityId),
      ActivityService.getComments(this.activityId),
    ]);
    const detailRes = results[0];
    const commentsRes = results[1];
    this.activity = detailRes.data || null;
    this.comments = commentsRes.code === 0 && commentsRes.data ? commentsRes.data : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '活动详情' })
      if (this.loading) {
        LoadingView()
      } else if (this.activity) {
        Scroll() {
          Column() {
            Text(this.activity.title)
              .fontSize(Constants.FONT_XXL)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .width('100%')

            Row() {
              Text(`组织者: ${this.activity.organizerName}`).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_HINT)
              Blank()
              Text(`${this.activity.participantCount}人参与`).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_PRIMARY)
            }
            .width('100%')
            .margin({ top: Constants.SPACE_SM })

            Divider().margin({ top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })

            this.DetailRow('地点', this.activity.location)
            this.DetailRow('时间', `${DateUtil.formatDateTime(this.activity.startTime)} - ${DateUtil.formatDateTime(this.activity.endTime)}`)
            this.DetailRow('状态', this.getStatusLabel())

            Text(this.activity.description)
              .fontSize(Constants.FONT_LG)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .lineHeight(26)
              .width('100%')
              .margin({ top: Constants.SPACE_LG })

            if (this.activity.status === 'upcoming' || this.activity.status === 'ongoing') {
              Blank().height(Constants.SPACE_XL)
              Button('我要参加')
                .width('100%')
                .height(44)
                .fontColor(Constants.COLOR_WHITE)
                .backgroundColor(Constants.COLOR_PRIMARY)
                .borderRadius(Constants.BUTTON_RADIUS)
                .onClick(async () => {
                  const res = await ActivityService.join(this.activityId);
                  if (res.code === 0) {
                    promptAction.openToast({ message: '报名成功' });
                    const detailRes = await ActivityService.getDetail(this.activityId);
                    this.activity = detailRes.data || this.activity;
                  } else {
                    promptAction.openToast({ message: res.message || '报名失败' });
                  }
                })
            }

            this.CommentsSection()
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
  CommentsSection() {
    Column() {
      Text('活动评论')
        .fontSize(Constants.FONT_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .width('100%')
        .margin({ top: Constants.SPACE_XL, bottom: Constants.SPACE_MD })

      if ((this.comments || []).length === 0) {
        EmptyView({ message: '暂无评论，快来抢沙发' })
      } else {
        ForEach(this.comments, (comment: ActivityComment) => {
          Row() {
            Text(comment.userName || '匿名用户')
              .fontSize(Constants.FONT_SM)
              .fontWeight(FontWeight.Medium)
              .fontColor(Constants.COLOR_PRIMARY)
            Text(comment.content)
              .fontSize(Constants.FONT_MD)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .layoutWeight(1)
              .margin({ left: Constants.SPACE_SM })
            Text(DateUtil.formatDateTime(comment.createdAt))
              .fontSize(Constants.FONT_SM)
              .fontColor(Constants.COLOR_TEXT_HINT)
          }
          .width('100%')
          .padding({ top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
          .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
        }, (comment: ActivityComment) => comment.id)
      }

      Row() {
        TextInput({ text: this.commentInput, placeholder: '说点什么…' })
          .layoutWeight(1)
          .height(40)
          .fontSize(Constants.FONT_MD)
          .borderRadius(Constants.BUTTON_RADIUS)
          .backgroundColor(Constants.COLOR_SURFACE_ALT)
          .onChange((value: string) => { this.commentInput = value; })

        Button('发送')
          .height(40)
          .margin({ left: Constants.SPACE_SM })
          .fontColor(Constants.COLOR_WHITE)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(Constants.BUTTON_RADIUS)
          .enabled(!this.sending && this.commentInput.trim().length > 0)
          .onClick(() => { this.sendComment(); })
      }
      .width('100%')
      .margin({ top: Constants.SPACE_MD })
    }
    .width('100%')
  }

  private async sendComment(): Promise<void> {
    const content = this.commentInput.trim();
    if (!content || this.sending) {
      return;
    }
    this.sending = true;
    try {
      const res = await ActivityService.addComment(this.activityId, content);
      if (res.code === 0 && res.data) {
        this.comments = [...this.comments, res.data];
        this.commentInput = '';
        promptAction.openToast({ message: '评论成功' });
      } else {
        promptAction.openToast({ message: res.message || '评论失败' });
      }
    } finally {
      this.sending = false;
    }
  }

  getStatusLabel(): string {
    switch (this.activity?.status) {
      case 'upcoming': return '即将开始';
      case 'ongoing': return '进行中';
      case 'ended': return '已结束';
      default: return '';
    }
  }

  @Builder
  DetailRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_HINT).width(60)
      Text(value).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_PRIMARY).layoutWeight(1)
    }
    .width('100%')
    .padding({ top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
  }
}
