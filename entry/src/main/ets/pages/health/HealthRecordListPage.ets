import { Constants } from '../../utils/Constants';
import { HealthService } from '../../services/HealthService';
import { HealthRecord } from '../../models/HealthModel';
import { HealthCard } from '../../components/card/HealthCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

@Entry
@Component
struct HealthRecordListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State records: HealthRecord[] = [];
  @State loading: boolean = true;

  async aboutToAppear(): Promise<void> {
    const studentId = this.userStore.getStudentId() || this.userStore.currentUser?.id;
    if (studentId) {
      const res = await HealthService.getRecords(studentId);
      this.records = res.code === 0 && res.data ? res.data : [];
    }
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '健康档案' })
      if (this.loading) {
        LoadingView()
      } else if (this.records.length === 0) {
        EmptyView({ message: '暂无健康记录' })
      } else {
        List() {
          ForEach(this.records, (record: HealthRecord) => {
            ListItem() {
              HealthCard({ record: record, onTap: () => { RouterUtil.toHealthDetail(record.id); } })
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
