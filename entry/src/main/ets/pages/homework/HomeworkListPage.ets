import { Constants } from '../../utils/Constants';
import { HomeworkService } from '../../services/HomeworkService';
import { Homework } from '../../models/HomeworkModel';
import { HomeworkCard } from '../../components/card/HomeworkCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { UserRole } from '../../models/UserModel';
import { PermissionGate } from '../../components/common/PermissionGate';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';

@Entry
@Component
struct HomeworkListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State homeworkList: Homework[] = [];
  @State loading: boolean = true;
  @State activeTab: string = 'active';

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;
    const res = await HomeworkService.getList(this.userStore.currentUser?.classId, 1, this.activeTab);
    this.homeworkList = res.code === 0 && res.data ? (res.data.list || []) : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '课后作业' }) {
        PermissionGate({ allowedRoles: [UserRole.TEACHER] }) {
          Button('+ 布置')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_WHITE)
            .backgroundColor(Constants.COLOR_PRIMARY)
            .borderRadius(Constants.BUTTON_RADIUS)
            .height(32)
            .onClick(() => { RouterUtil.toAssignHomework(); })
        }
      }

      // Tab filter
      Row() {
        this.FilterTab('全部', 'all')
        this.FilterTab('进行中', 'active')
        this.FilterTab('已截止', 'expired')
      }
      .width('100%')
      .padding({ left: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })

      if (this.loading) {
        LoadingView()
      } else {
        List() {
          ForEach(
            (this.homeworkList || []).filter(h => this.activeTab === 'all' || h.status === this.activeTab),
            (hw: Homework) => {
              ListItem() {
                HomeworkCard({ homework: hw, onTap: () => { RouterUtil.toHomeworkDetail(hw.id); } })
              }
            },
            (hw: Homework) => hw.id
          )
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
  FilterTab(label: string, value: string) {
    Text(label)
      .fontSize(Constants.FONT_MD)
      .fontColor(this.activeTab === value ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT)
      .fontWeight(this.activeTab === value ? FontWeight.Bold : FontWeight.Normal)
      .padding({ left: Constants.SPACE_MD, right: Constants.SPACE_MD, top: 6, bottom: 6 })
      .onClick(() => {
        this.activeTab = value;
        this.loadData();
      })
  }
}
