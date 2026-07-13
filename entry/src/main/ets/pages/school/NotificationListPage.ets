import { Constants } from '../../utils/Constants';
import { NoticeService } from '../../services/NoticeService';
import { Notice } from '../../models/NoticeModel';
import { NotificationItem } from '../../components/list/NotificationItem';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { SearchBar } from '../../components/common/SearchBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

@Entry
@Component
struct NotificationListPage {
  @State notices: Notice[] = [];
  @State loading: boolean = true;
  @State keyword: string = '';

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;
    const res = await NoticeService.getList({ page: 1, pageSize: 20, keyword: this.keyword });
    this.notices = res.code === 0 && res.data ? (res.data.list || []) : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '通知公告' })
      SearchBar({ value: $keyword, placeholder: '搜索通知...', onSearch: () => { this.loadData(); } })

      if (this.loading) {
        LoadingView()
      } else if ((this.notices || []).length === 0) {
        EmptyView({ message: '暂无通知' })
      } else {
        List() {
          ForEach(this.notices || [], (notice: Notice) => {
            ListItem() {
              NotificationItem({ notice: notice, onTap: () => { RouterUtil.toNotificationDetail(notice.id); } })
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
}
