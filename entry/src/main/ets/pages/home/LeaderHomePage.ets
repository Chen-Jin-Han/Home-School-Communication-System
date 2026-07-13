import { UserRole } from '../../models/UserModel';
import { MobileWorkbench } from '../../components/home/MobileWorkbench';

@Entry
@Component
struct LeaderHomePage {
  build() {
    Column() {
      MobileWorkbench({ role: UserRole.LEADER })
    }
    .width('100%')
    .height('100%')
  }
}
