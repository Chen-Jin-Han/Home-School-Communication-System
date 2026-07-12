import { UserRole } from '../../models/UserModel';
import { MobileWorkbench } from '../../components/home/MobileWorkbench';

@Entry
@Component
struct ParentHomePage {
  build() {
    MobileWorkbench({ role: UserRole.PARENT })
  }
}
