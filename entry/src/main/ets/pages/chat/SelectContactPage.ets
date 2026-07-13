import { Constants } from '../../utils/Constants';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { SearchBar } from '../../components/common/SearchBar';

interface ContactItem {
  name: string;
  role: string;
}

const mockContacts: ContactItem[] = [
  { name: '李老师', role: '教师' } as ContactItem,
  { name: '王校长', role: '领导' } as ContactItem,
  { name: '张伟', role: '家长' } as ContactItem,
  { name: '张小伟', role: '学生' } as ContactItem,
];

@Entry
@Component
struct SelectContactPage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State searchKeyword: string = '';

  build() {
    Column() {
      AppNavBar({ title: '选择联系人' })
      SearchBar({ value: $searchKeyword, placeholder: '搜索联系人...' })
      Scroll() {
        Column() {
          ForEach(
            mockContacts,
            (contact: ContactItem) => {
              Row() {
                Column() {
                  Text(contact.name.charAt(0)).fontSize(18).fontColor('#FFF').fontWeight(FontWeight.Bold)
                }
                .width(40).height(40).borderRadius(20).backgroundColor(Constants.COLOR_PRIMARY).justifyContent(FlexAlign.Center)

                Column() {
                  Text(contact.name).fontSize(Constants.FONT_LG).fontColor(Constants.COLOR_TEXT_PRIMARY)
                  Text(contact.role).fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_TEXT_HINT).margin({ top: 2 })
                }
                .margin({ left: Constants.SPACE_MD })
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding(Constants.SPACE_MD)
              .backgroundColor(Constants.COLOR_WHITE)
              .border({ width: { bottom: 0.5 }, color: Constants.COLOR_DIVIDER })
            }
          )
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }
}
