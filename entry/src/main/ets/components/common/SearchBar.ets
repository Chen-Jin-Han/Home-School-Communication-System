import { Constants } from '../../utils/Constants';
import { ElementIcon } from './ElementIcon';

@Component
export struct SearchBar {
  @Prop placeholder: string = '搜索';
  @Link value: string;
  onSearch?: (keyword: string) => void;

  build() {
    Row() {
      ElementIcon({ name: 'Search', size: 18, color: Constants.COLOR_TEXT_HINT })
        .margin({ left: Constants.SPACE_MD, right: Constants.SPACE_SM })

      TextInput({ placeholder: this.placeholder, text: this.value })
        .layoutWeight(1)
        .height(40)
        .backgroundColor(Color.Transparent)
        .fontSize(Constants.FONT_MD)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .placeholderColor(Constants.COLOR_TEXT_HINT)
        .borderRadius(0)
        .onChange((value: string) => {
          this.value = value;
        })
        .onSubmit(() => {
          if (this.onSearch) {
            this.onSearch(this.value);
          }
        })

      if (this.value) {
        ElementIcon({ name: 'Close', size: 18, color: Constants.COLOR_TEXT_HINT })
          .margin({ right: Constants.SPACE_MD })
          .onClick(() => {
            this.value = '';
            if (this.onSearch) {
              this.onSearch('');
            }
          })
      }
    }
    .width('100%')
    .height(44)
    .backgroundColor(Constants.COLOR_SURFACE)
    .borderRadius(Constants.CARD_RADIUS)
    .border({ width: 0.5, color: Constants.COLOR_BORDER })
    .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
  }
}
