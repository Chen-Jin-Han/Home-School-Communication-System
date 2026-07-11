import { Constants } from '../../utils/Constants';
import { GradeService } from '../../services/GradeService';
import { GradeReport } from '../../models/GradeModel';
import { GradeCard } from '../../components/card/GradeCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

@Entry
@Component
struct GradeListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State reports: GradeReport[] = [];
  @State loading: boolean = true;

  async aboutToAppear(): Promise<void> {
    const studentId = this.userStore.getStudentId() || this.userStore.currentUser?.id;
    if (studentId) {
      const res = await GradeService.getReports(studentId);
      this.reports = res.data;
    }
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '学生成绩' })
      if (this.loading) {
        LoadingView()
      } else if (this.reports.length === 0) {
        EmptyView({ message: '暂无成绩记录' })
      } else {
        List() {
          ForEach(this.reports, (report: GradeReport) => {
            ListItem() {
              GradeCard({ report: report, onTap: () => { RouterUtil.toGradeDetail(report.id); } })
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
