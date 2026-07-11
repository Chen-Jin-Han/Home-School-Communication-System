import { Constants } from '../../utils/Constants';
import { SchoolService } from '../../services/SchoolService';
import { OrgNode } from '../../models/SchoolModel';
import { RouterUtil } from '../../utils/RouterUtil';
import { AppNavBar } from '../../components/common/AppNavBar';
import { LoadingView } from '../../components/common/LoadingView';

@Entry
@Component
struct OrgStructurePage {
  @State orgTree: OrgNode | null = null;
  @State loading: boolean = true;
  @State expandedGrades: Set<string> = new Set(['grade3']);

  async aboutToAppear(): Promise<void> {
    const res = await SchoolService.getOrgTree('s001');
    this.orgTree = res.data;
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
              Text('🏫').fontSize(24)
              Text(this.orgTree.name).fontSize(Constants.FONT_XL).fontWeight(FontWeight.Bold).margin({ left: Constants.SPACE_SM })
            }
            .width('100%')
            .padding(Constants.SPACE_LG)
            .backgroundColor(Constants.COLOR_WHITE)

            // Grades
            ForEach(this.orgTree.children || [], (grade: OrgNode) => {
              Column() {
                Row() {
                  Text('📚').fontSize(20)
                  Text(grade.name).fontSize(Constants.FONT_LG).fontWeight(FontWeight.Bold).layoutWeight(1).margin({ left: Constants.SPACE_SM })
                  Text(this.expandedGrades.has(grade.id) ? '收起' : '展开').fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_PRIMARY)
                }
                .width('100%')
                .padding(Constants.SPACE_MD)
                .backgroundColor(Constants.COLOR_WHITE)
                .margin({ top: Constants.SPACE_SM })
                .onClick(() => {
                  if (this.expandedGrades.has(grade.id)) {
                    this.expandedGrades.delete(grade.id);
                  } else {
                    this.expandedGrades.add(grade.id);
                  }
                  this.expandedGrades = new Set(this.expandedGrades);
                })

                if (this.expandedGrades.has(grade.id)) {
                  ForEach(grade.children || [], (cls: OrgNode) => {
                    Row() {
                      Text('  📖').fontSize(16)
                      Text(cls.name).fontSize(Constants.FONT_MD).fontColor(Constants.COLOR_TEXT_SECONDARY).layoutWeight(1).margin({ left: Constants.SPACE_SM })
                      Text('查看').fontSize(Constants.FONT_SM).fontColor(Constants.COLOR_PRIMARY)
                    }
                    .width('100%')
                    .padding({ left: Constants.SPACE_XXL, right: Constants.SPACE_MD, top: Constants.SPACE_SM, bottom: Constants.SPACE_SM })
                    .backgroundColor(Constants.COLOR_WHITE)
                    .border({ width: { top: 0.5 }, color: Constants.COLOR_DIVIDER })
                    .onClick(() => { RouterUtil.toStudentList(cls.id); })
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
}
