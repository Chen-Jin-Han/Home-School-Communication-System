import { Constants } from '../../utils/Constants';

export interface TabItem {
  icon: string;
  activeIcon: string;
  label: string;
  badge?: number;
}

@Component
export struct AppTabBar {
  @Link currentIndex: number;
  items: TabItem[] = [];

  build() {
    Row() {
      ForEach(this.items, (item: TabItem, index: number) => {
        Column() {
          Stack() {
            Text(item.label)
              .fontSize(Constants.FONT_XL)
              .fontColor(index === this.currentIndex ? Constants.COLOR_PRIMARY : Constants.COLOR_TEXT_HINT)
            if (item.badge && item.badge > 0) {
              Badge({ count: item.badge, value: '' })
                .position({ x: 18, y: -6 })
            }
          }
        }
        .layoutWeight(1)
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentIndex = index;
        })
      })
    }
    .width('100%')
    .height(Constants.TAB_BAR_HEIGHT)
    .backgroundColor(Constants.COLOR_WHITE)
  }
}
