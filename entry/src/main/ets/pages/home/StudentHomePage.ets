import { UserRole } from '../../models/UserModel';
import { MobileWorkbench } from '../../components/home/MobileWorkbench';

@Entry
@Component
struct StudentHomePage {
  build() {
    Column() {
      MobileWorkbench({ role: UserRole.STUDENT })
    }
    .width('100%')
    .height('100%')
  }
}
