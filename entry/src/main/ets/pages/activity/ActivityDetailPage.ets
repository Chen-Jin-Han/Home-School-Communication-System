import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { ActivityService } from '../../services/ActivityService';
import { Activity } from '../../models/ActivityModel';
import { DateUtil } from '../../utils/DateUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';

interface ActivityDetailParams {
  activityId: string;
}

@Entry
@Component
struct ActivityDetailPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State activity: Activity | null = null;
  @State loading: boolean = true;
  private activityId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as ActivityDetailParams;
    this.activityId = params.activityId;
    const res = await ActivityService.getDetail(this.activityId);
    this.activity = res.data || null;
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
              Blank().height(Constants.SPACE_XXL)
              Button('我要参加')
                .width('100%')
                .height(44)
                .fontColor(Constants.COLOR_WHITE)
                .backgroundColor(Constants.COLOR_PRIMARY)
                .borderRadius(Constants.BUTTON_RADIUS)
                .onClick(async () => {
                  await ActivityService.join(this.activityId);
                  promptAction.showToast({ message: '报名成功' });
                })
            }
          }
          .width('100%')
          .padding(Constants.SPACE_LG)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_WHITE)
  }

  getStatusLabel(): string {
    switch (this.activity?.status) {
      case 'upcoming': return '即将开始';
      case 'ongoing': return '进行中';
      case 'ended': return '已结束';
    }
    return '';
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
