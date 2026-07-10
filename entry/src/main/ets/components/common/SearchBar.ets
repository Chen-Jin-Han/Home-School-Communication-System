import { Constants } from '../../utils/Constants';

@Component
export struct SearchBar {
  @Prop placeholder: string = '搜索...';
  @Link value: string;
  onSearch?: (keyword: string) => void;

  build() {
    Row() {
      Image($r('sys.symbol.magnifyingglass'))
        .width(20)
        .height(20)
        .fillColor(Constants.COLOR_TEXT_HINT)
        .margin({ left: Constants.SPACE_MD, right: Constants.SPACE_SM })
      TextInput({ placeholder: this.placeholder, text: this.value })
        .layoutWeight(1)
        .height(36)
        .backgroundColor(Color.Transparent)
        .fontSize(Constants.FONT_MD)
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
        Image($r('sys.symbol.xmark_circle_fill'))
          .width(18)
          .height(18)
          .fillColor(Constants.COLOR_TEXT_HINT)
          .margin({ right: Constants.SPACE_MD })
          .onClick(() => {
            this.value = '';
          })
      }
    }
    .width('100%')
    .height(40)
    .backgroundColor(Constants.COLOR_DIVIDER)
    .borderRadius(20)
    .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
  }
}
