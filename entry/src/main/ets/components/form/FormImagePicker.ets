import { Constants } from '../../utils/Constants';
import { ElementIcon } from '../common/ElementIcon';

@Component
export struct FormImagePicker {
  @Link images: string[];
  @Prop maxCount: number = 9;
  onAdd?: () => void;
  onRemove?: (index: number) => void;

  build() {
    Row() {
      ForEach(this.images, (url: string, index: number) => {
        Stack() {
          Image(url)
            .width(80)
            .height(80)
            .borderRadius(6)
            .objectFit(ImageFit.Cover)

          ElementIcon({ name: 'Close', size: 20, color: Constants.COLOR_DANGER })
            .position({ x: 66, y: -6 })
            .onClick(() => {
              if (this.onRemove) {
                this.onRemove(index);
              }
            })
        }
        .margin({ right: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
      })

      if (this.images.length < this.maxCount) {
        Column() {
          ElementIcon({ name: 'Image', size: 28, color: Constants.COLOR_TEXT_HINT })
          Text('添加图片')
            .fontSize(Constants.FONT_SM)
            .fontColor(Constants.COLOR_TEXT_HINT)
            .margin({ top: 4 })
        }
        .width(80)
        .height(80)
        .border({ width: 1, color: Constants.COLOR_BORDER, style: BorderStyle.Dashed })
        .borderRadius(6)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          if (this.onAdd) {
            this.onAdd();
          }
        })
      }
    }
    .width('100%')
    .flexWrap(FlexWrap.Wrap)
  }
}
