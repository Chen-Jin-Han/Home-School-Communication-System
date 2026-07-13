import { Constants } from '../../utils/Constants';
import { NoticeService } from '../../services/NoticeService';
import { Notice } from '../../models/NoticeModel';
import { NoticeCard } from '../../components/card/NoticeCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

@Entry
@Component
struct MyPublishedPage {
  @State notices: Notice[] = [];
  @State loading: boolean = true;

  async aboutToAppear(): Promise<void> {
    const res = await NoticeService.getList({ page: 1, pageSize: 50 });
    this.notices = res.code === 0 && res.data ? (res.data.list || []) : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '我的发布' })
      if (this.loading) {
        LoadingView()
      } else if ((this.notices || []).length === 0) {
        EmptyView({ message: '暂无发布记录' })
      } else {
        List() {
          ForEach(this.notices || [], (notice: Notice) => {
            ListItem() {
              NoticeCard({ notice: notice, onTap: () => { RouterUtil.toNotificationDetail(notice.id); } })
            }
          })
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }
}
