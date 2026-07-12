import { UserRole } from '../../models/UserModel';
import { MobileWorkbench } from '../../components/home/MobileWorkbench';

@Entry
@Component
struct StudentHomePage {
  build() {
    MobileWorkbench({ role: UserRole.STUDENT })
  }
}
