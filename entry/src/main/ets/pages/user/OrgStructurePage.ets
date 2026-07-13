import { Constants } from '../../utils/Constants';
import { SchoolService } from '../../services/SchoolService';
import { OrgNode } from '../../models/SchoolModel';
import { RouterUtil } from '../../utils/RouterUtil';
import { UserStore } from '../../store/UserStore';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';
import { ElementIcon } from '../../components/common/ElementIcon';

@Entry
@Component
struct OrgStructurePage {
  @Provide userStore: UserStore = UserStore.getInstance();
  @State orgTree: OrgNode | null = null;
  @State loading: boolean = true;
  @State expandedGrades: Set<string> = new Set(['3']);

  async aboutToAppear(): Promise<void> {
    const res = await SchoolService.getOrgTree(this.userStore.currentUser?.schoolId || '1');
    this.orgTree = res.code === 0 && res.data ? res.data : null;
    if (this.orgTree?.children && this.orgTree.children.length > 0) {
      this.expandedGrades = new Set([String(this.orgTree.children[0].id)]);
    }
    this.loading = false;
  }

  build() {
    Column() {
      AppNavBar({ title: '组织架构' })
      if (this.loading) {
        LoadingView()
      } else if (this.orgTree) {
        Scroll() {
          Column() {
            // School node
            Row() {
              this.NodeIcon('School', Constants.COLOR_PRIMARY)
              Text(this.orgTree.name).fontSize(Constants.FONT_XL).fontWeight(FontWeight.Bold).margin({ left: Constants.SPACE_SM })
            }
            .width('100%')
            .padding(Constants.SPACE_LG)
            .backgroundColor(Constants.COLOR_WHITE)
            .borderRadius(Constants.CARD_RADIUS)
            .border({ width: 1, color: Constants.COLOR_BORDER })
            .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_LG })

            // Grades
            ForEach(this.orgTree.children || [], (grade: OrgNode) => {
              Column() {
                Row() {
                  this.NodeIcon('Team', Constants.COLOR_PRIMARY)
                  Text(grade.name).fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).layoutWeight(1).margin({ left: Constants.SPACE_SM })
                  Text(this.expandedGrades.has(String(grade.id)) ? '收起' : '展开').fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_PRIMARY)
                }
                .width('100%')
                .padding(Constants.SPACE_MD)
                .backgroundColor(Constants.COLOR_WHITE)
                .borderRadius(Constants.CARD_RADIUS)
                .border({ width: 1, color: Constants.COLOR_BORDER })
                .margin({ left: Constants.SPACE_LG, right: Constants.SPACE_LG, top: Constants.SPACE_SM })
                .onClick(() => {
                  const gradeId = String(grade.id);
                  if (this.expandedGrades.has(gradeId)) {
                    this.expandedGrades.delete(gradeId);
                  } else {
                    this.expandedGrades.add(gradeId);
                  }
                  this.expandedGrades = new Set(this.expandedGrades);
                })

                if (this.expandedGrades.has(String(grade.id))) {
                  ForEach(grade.children || [], (cls: OrgNode) => {
                    Row() {
                      this.NodeIcon('Document', Constants.COLOR_TEXT_HINT)
                      Text(cls.name).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_SECONDARY).layoutWeight(1).margin({ left: Constants.SPACE_SM })
                      Text('查看').fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_PRIMARY)
                    }
                    .width('100%')
                    .padding({ left: Constants.SPACE_XL, right: Constants.SPACE_LG, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
                    .backgroundColor(Constants.COLOR_WHITE)
                    .margin({ left: Constants.SPACE_XXL, right: Constants.SPACE_LG })
                    .border({ width: { top: 0.5 }, color: Constants.COLOR_DIVIDER })
                    .onClick(() => { RouterUtil.toStudentList(String(cls.id)); })
                  })
                }
              }
            })

            Blank().height(20)
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
  NodeIcon(name: string, color: string) {
    Row() {
      ElementIcon({ name: name, iconSize: 18, color: color })
    }
    .width(34)
    .height(34)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(Constants.COLOR_PRIMARY_SOFT)
    .borderRadius(10)
  }
}
