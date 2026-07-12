import { UserRole } from '../../models/UserModel';
import { MobileWorkbench } from '../../components/home/MobileWorkbench';

@Entry
@Component
struct TeacherHomePage {
  build() {
    MobileWorkbench({ role: UserRole.TEACHER })
  }
}
