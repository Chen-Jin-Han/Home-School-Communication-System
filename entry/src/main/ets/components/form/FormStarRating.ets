import { Constants } from '../../utils/Constants';

@Component
export struct FormStarRating {
  @Link rating: number;
  @Prop maxRating: number = 5;
  @Prop starSize: number = 32;
  onChange?: (rating: number) => void;

  build() {
    Row() {
      ForEach(Array.from({ length: this.maxRating }), (_: undefined, i: number) => {
        Text(i < this.rating ? '★' : '☆')
          .fontSize(this.starSize)
          .fontColor(i < this.rating ? '#FAAD14' : Constants.COLOR_BORDER)
          .margin({ right: Constants.SPACE_XS })
          .onClick(() => {
            this.rating = i + 1;
            if (this.onChange) {
              this.onChange(this.rating);
            }
          })
      })
    }
  }
}
