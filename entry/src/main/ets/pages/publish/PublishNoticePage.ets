import { promptAction } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { NoticeService } from '../../services/NoticeService';
import { UserStore } from '../../store/UserStore';
import { RouterUtil } from '../../utils/RouterUtil';
import { Notice, NoticeType } from '../../models/NoticeModel';
import { AppNavBar } from '../../components/common/AppNavBar';
import { FormRow } from '../../components/form/FormRow';
import { FormTextInput } from '../../components/form/FormTextInput';
import { FormTextArea } from '../../components/form/FormTextArea';

interface NoticeTypeOption {
  type: string;
  label: string;
}

@Entry
@Component
struct PublishNoticePage {
  @State title: string = '';
  @State content: string = '';
  @State noticeType: string = 'notification';
  @State loading: boolean = false;

  build() {
    Column() {
      AppNavBar({ title: '发布通知' })
      Scroll() {
        Column() {
          FormRow({ label: '标题', required: true }) {
            FormTextInput({ value: $title, placeholder: '请输入通知标题', maxLength: 50 })
          }
          FormRow({ label: '类型' }) {
            Row() {
              ForEach(
                [
                  { type: 'notification', label: '通知' },
                  { type: 'announcement', label: '公告' },
                  { type: 'news', label: '新闻' },
                ],
                (item: NoticeTypeOption) => {
                  Column() {
                    Text(item.label)
                      .fontSize(Constants.FONT_MD)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(this.noticeType === item.type ? Constants.COLOR_WHITE : Constants.COLOR_TEXT_PRIMARY)
                  }
                  .layoutWeight(1)
                  .height(38)
                  .backgroundColor(this.noticeType === item.type ? Constants.COLOR_PRIMARY : Constants.COLOR_SURFACE)
                  .border({
                    width: 1,
                    color: this.noticeType === item.type ? Constants.COLOR_PRIMARY : Constants.COLOR_BORDER,
                  })
                  .borderRadius(Constants.BUTTON_RADIUS)
                  .justifyContent(FlexAlign.Center)
                  .margin({ right: Constants.SPACE_SM })
                  .onClick(() => {
                    this.noticeType = item.type;
                  })
                }
              )
            }
            .width('100%')
          }
          FormRow({ label: '内容', required: true }) {
            FormTextArea({ value: $content, placeholder: '请输入通知内容', maxLength: 2000 })
          }

          Button(this.loading ? '发布中...' : '发布')
            .width('90%')
            .height(48)
            .fontSize(Constants.FONT_LG)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .margin({ top: Constants.SPACE_XXL })
            .enabled(!this.loading)
            .onClick(() => {
              this.handlePublish();
            })
        }
        .width('100%')
        .padding({ top: Constants.SPACE_LG })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  async handlePublish(): Promise<void> {
    if (!this.title) {
      promptAction.showToast({ message: '请输入标题' });
      return;
    }
    if (!this.content) {
      promptAction.showToast({ message: '请输入内容' });
      return;
    }

    this.loading = true;
    const store = UserStore.getInstance();
    const notice: Notice = {
      id: `n_${Date.now()}`,
      title: this.title,
      summary: this.content.substring(0, 100),
      content: this.content,
      type: this.noticeType as NoticeType,
      publisherId: store.currentUser?.id || '',
      publisherName: store.currentUser?.name || '',
      publisherAvatar: '',
      scope: 'all',
      attachments: [],
      isTop: false,
      viewCount: 0,
      createdAt: Date.now(),
      updatedAt: Date.now(),
    };
    const res = await NoticeService.create(notice);
    this.loading = false;
    if (res.code === 0) {
      promptAction.showToast({ message: '发布成功' });
      RouterUtil.back();
    } else {
      promptAction.showToast({ message: res.message || '发布失败' });
    }
  }
}
