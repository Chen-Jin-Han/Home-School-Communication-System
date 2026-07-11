import { UserRole } from '../../models/UserModel';
import { UserStore } from '../../store/UserStore';

@Component
export struct PermissionGate {
  allowedRoles: UserRole[] = [];
  @BuilderParam children?: () => void;

  build() {
    if (UserStore.getInstance().currentUser) {
      if (this.hasPermission()) {
        if (this.children) {
          this.children();
        }
      }
    }
  }

  hasPermission(): boolean {
    const currentRole = UserStore.getInstance().currentUser!.role;
    return this.allowedRoles.includes(currentRole);
  }
}
