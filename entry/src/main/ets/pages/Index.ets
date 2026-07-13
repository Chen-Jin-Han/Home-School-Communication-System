import { UserStore } from '../store/UserStore';
import { RouterUtil } from '../utils/RouterUtil';
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
      // Continue to login when local auth cache cannot be restored.
    }
    this.loading = false;
    try {
      RouterUtil.toHomeFromSplash();
    } catch (e) {
      RouterUtil.toLogin();
    }
  }

  build() {
    Stack() {
      Column() {
        Image($r('app.media.app_logo'))
          .width(112)
          .height(112)
          .borderRadius(28)
          .shadow({ radius: 18, color: '#1F4A7C22', offsetY: 8 })

        Text('家校通')
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor('#174A7C')
          .margin({ top: 22 })

        Text('华迪 HuaDee')
          .fontSize(Constants.FONT_LG)
          .fontColor('#4A90D9')
          .margin({ top: 8 })

        if (this.loading) {
          LoadingProgress()
            .width(32)
            .height(32)
            .color('#4A90D9')
            .margin({ top: 42 })
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F4F8FC')
  }
}
