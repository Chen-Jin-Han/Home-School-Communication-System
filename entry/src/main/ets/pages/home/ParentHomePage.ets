import { UserRole } from '../../models/UserModel';
import { MobileWorkbench } from '../../components/home/MobileWorkbench';

@Entry
@Component
struct ParentHomePage {
  build() {
    Column() {
      MobileWorkbench({ role: UserRole.PARENT })
    }
    .width('100%')
    .height('100%')
  }
}
