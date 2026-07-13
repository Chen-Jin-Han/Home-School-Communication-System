import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { NoticeService } from '../../services/NoticeService';
import { Notice } from '../../models/NoticeModel';
import { DateUtil } from '../../utils/DateUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';

interface NotificationDetailParams {
  noticeId: string;
}

@Entry
@Component
struct NotificationDetailPage {
  @State notice: Notice | null = null;
  @State loading: boolean = true;
  private noticeId: string = '';

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as NotificationDetailParams;
    this.noticeId = params.noticeId;
    const res = await NoticeService.getDetail(this.noticeId);
    this.notice = res.data || null;
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '通知详情' })
      if (this.loading) {
        LoadingView()
      } else if (this.notice) {
        Scroll() {
          Column() {
            Text(this.notice.title)
              .fontSize(Constants.FONT_XXL)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .width('100%')

            Row() {
              Text(this.notice.publisherName)
                .fontSize(Constants.FONT_SM)
                .fontColor(Constants.COLOR_PRIMARY)
              Blank()
              Text(DateUtil.formatDateTime(this.notice.createdAt))
                .fontSize(Constants.FONT_SM)
                .fontColor(Constants.COLOR_TEXT_HINT)
              Text(` 阅读 ${this.notice.viewCount}`)
                .fontSize(Constants.FONT_SM)
                .fontColor(Constants.COLOR_TEXT_HINT)
            }
            .width('100%')
            .margin({ top: Constants.SPACE_MD })

            Divider()
              .margin({ top: Constants.SPACE_MD, bottom: Constants.SPACE_MD })

            Text(this.notice.content)
              .fontSize(Constants.FONT_LG)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .lineHeight(28)
              .width('100%')
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
