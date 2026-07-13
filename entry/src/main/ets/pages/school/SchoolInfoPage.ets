import { Constants } from '../../utils/Constants';
import { SchoolService } from '../../services/SchoolService';
import { School } from '../../models/SchoolModel';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';

@Entry
@Component
struct SchoolInfoPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State school: School | null = null;
  @State loading: boolean = true;

  async aboutToAppear(): Promise<void> {
    const res = await SchoolService.getSchoolInfo(this.userStore.currentUser?.schoolId || '1');
    if (res.data) {
      this.school = res.data;
    }
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '学校信息' })
      if (this.loading) {
        LoadingView()
      } else if (this.school) {
        Scroll() {
          Column() {
            Text(this.school.name)
              .fontSize(Constants.FONT_XXL)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
              .width('100%')
              .padding({ left: Constants.SPACE_LG, top: Constants.SPACE_XL })

            Text(this.school.description)
              .fontSize(Constants.FONT_MD)
              .fontColor(Constants.COLOR_TEXT_SECONDARY)
              .lineHeight(24)
              .width('100%')
              .padding({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_MD })

            this.InfoRow('地址', this.school.address)
            this.InfoRow('电话', this.school.phone)
            this.InfoRow('校长', this.school.principal)
            this.InfoRow('建校时间', `${this.school.foundedYear}年`)
          }
          .width('100%')
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_HINT).width(80)
      Text(value).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_PRIMARY).layoutWeight(1)
    }
    .width('100%')
    .padding(Constants.SPACE_LG)
    .backgroundColor(Constants.COLOR_WHITE)
    .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
    .margin({ top: Constants.SPACE_LG })
  }
}
