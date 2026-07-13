import { Constants } from '../../utils/Constants';
import { ActivityService } from '../../services/ActivityService';
import { Activity } from '../../models/ActivityModel';
import { ActivityCard } from '../../components/card/ActivityCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

@Entry
@Component
struct ActivityListPage {
  @State activities: Activity[] = [];
  @State loading: boolean = true;
  @State statusFilter: string = 'upcoming';

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;
    const res = await ActivityService.getList(this.statusFilter);
    this.activities = res.code === 0 && res.data ? (res.data.list || []) : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '学生活动' })

      Row() {
        this.FilterTab('即将开始', 'upcoming')
        this.FilterTab('进行中', 'ongoing')
        this.FilterTab('已结束', 'ended')
      }
      .width('100%')
      .padding({ left: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })

      if (this.loading) {
        LoadingView()
      } else if ((this.activities || []).length === 0) {
        EmptyView({ message: '暂无可显示的活动' })
      } else {
        List() {
          ForEach(this.activities || [], (act: Activity) => {
            ListItem() {
              ActivityCard({ activity: act, onTap: () => { RouterUtil.toActivityDetail(act.id); } })
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

  @Builder
  FilterTab(label: string, value: string) {
    Text(label)
      .fontSize(Constants.FONT_MD)
      .fontColor(this.statusFilter === value ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT)
      .fontWeight(this.statusFilter === value ? FontWeight.Bold : FontWeight.Normal)
      .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD, top: 6, bottom: 6 })
      .onClick(() => {
        this.statusFilter = value;
        this.loadData();
      })
  }
}
