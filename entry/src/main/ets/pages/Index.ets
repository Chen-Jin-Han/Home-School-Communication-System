import { UserStore } from '../store/UserStore';
import { RouterUtil } from '../utils/RouterUtil';
import { StorageUtil } from '../utils/StorageUtil';
import { Constants } from '../utils/Constants';

@Entry
@Component
struct Index {
  @State loading: boolean = true;

  async aboutToAppear(): Promise<void> {
    try {
      const store = UserStore.getInstance();
      await store.init();
    } catch (e) {
      // ignore init errors, proceed to login
    }
    await new Promise<void>(r => setTimeout(r, 800));
    this.loading = false;
    try {
      RouterUtil.toHomeFromSplash();
    } catch (e) {
      RouterUtil.toLogin();
    }
  }

  build() {
    Column() {
      Column() {
        Text('家校通')
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_PRIMARY)
        Text('Hwadee-FSC')
          .fontSize(Constants.FONT_LG)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: Constants.SPACE_SM })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      if (this.loading) {
        LoadingProgress()
          .width(30)
          .height(30)
          .color(Constants.COLOR_PRIMARY)
          .position({ x: '50%', y: '65%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_WHITE)
  }
}
