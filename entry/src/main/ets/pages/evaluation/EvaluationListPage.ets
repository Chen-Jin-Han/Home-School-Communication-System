import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { EvaluationService } from '../../services/EvaluationService';
import { Evaluation } from '../../models/EvaluationModel';
import { EvaluationCard } from '../../components/card/EvaluationCard';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { EmptyView } from '../../components/common/EmptyView';

interface EvaluationListParams {
  studentId?: string;
}

@Entry
@Component
struct EvaluationListPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State evaluations: Evaluation[] = [];
  @State loading: boolean = true;

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as EvaluationListParams;
    const studentId = (params && params.studentId) || this.userStore.getStudentId() || this.userStore.currentUser?.id;
    if (!studentId) {
      this.loading = false;
      return;
    }
    const res = await EvaluationService.getList(studentId);
    this.evaluations = res.code === 0 && res.data ? res.data : [];
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '学生评价' })
      if (this.loading) {
        LoadingView()
      } else if ((this.evaluations || []).length === 0) {
        EmptyView({ message: '暂无评价记录' })
      } else {
        List() {
          ForEach(this.evaluations || [], (evaluation: Evaluation) => {
            ListItem() {
              EvaluationCard({ evaluation: evaluation })
            }
          }, (evaluation: Evaluation) => evaluation.id)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }
}
