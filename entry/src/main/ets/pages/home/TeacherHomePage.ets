import { UserRole } from '../../models/UserModel';
import { MobileWorkbench } from '../../components/home/MobileWorkbench';

@Entry
@Component
struct TeacherHomePage {
  build() {
    Column() {
      MobileWorkbench({ role: UserRole.TEACHER })
    }
    .width('100%')
    .height('100%')
  }
}
