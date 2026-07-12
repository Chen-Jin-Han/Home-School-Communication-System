import { UserRole } from '../../models/UserModel';
import { MobileWorkbench } from '../../components/home/MobileWorkbench';

@Entry
@Component
struct LeaderHomePage {
  build() {
    MobileWorkbench({ role: UserRole.LEADER })
  }
}
