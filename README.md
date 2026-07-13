# 家校通 Home-School Communication System

<div align="center">
  <img src="./docs/assets/app_logo.png" alt="家校通 华迪 HuaDee Logo" width="180">
  <br>
  <strong>家校通 · 华迪 HuaDee</strong>
</div>

家校通是一套面向学校、教师、学生与家长的移动端家校协同系统。当前项目已经从早期 Spring Boot 后端迁移为 Flask + MySQL 架构，前端采用 HarmonyOS ArkTS / ArkUI 实现，整体目标是支持企业级部署、角色化工作台、真实后端接口访问和移动端模拟器/真机调试。

当前 App 桌面名称为“家校通”，主界面已经重构为移动端工作台样式，并覆盖家长、学生、教师、领导四类角色。系统包含通知公告、课后作业、作业提交、考勤记录、成绩报告、健康档案、学生评价、即时消息、联系人选择、校园活动、学校信息、组织架构、个人主页和发布管理等核心功能。

## 当前状态

- 移动端：HarmonyOS ArkTS 工程，入口模块为 `entry`，主入口页面为 `entry/src/main/ets/pages/Index.ets`。
- 后端：Flask 3 应用，使用 SQLAlchemy ORM、JWT 鉴权、统一响应结构和 Gunicorn 部署入口。
- 数据库：MySQL 8.x，Docker Compose 默认创建 `hwadee_fsc` 数据库并持久化数据卷。
- 部署：支持 `docker compose up -d --build` 一键启动 MySQL + Flask 后端。
- 接口模式：前端当前关闭 Mock，默认访问公网后端 `http://8.218.156.55:8080`。
- UI 状态：主工作台使用统一图标容器、底部导航、公共返回栏、空状态和接口异常兜底，避免后端返回空数据时直接闪退。
- 邮箱登录：支持手机号或邮箱作为账号登录，当前不启用邮箱验证码，因此没有邮件服务成本。

## 技术栈

| 层级 | 当前技术 |
| --- | --- |
| 移动端 | HarmonyOS / ArkTS / ArkUI / DevEco Studio / Hvigor |
| 移动端状态与服务 | ArkTS 页面状态、服务层封装、角色化路由、空数据兜底 |
| 后端框架 | Flask 3 / Flask-CORS / Flask-Migrate / Gunicorn |
| 数据访问 | SQLAlchemy / PyMySQL |
| 数据库 | MySQL 8.x |
| 鉴权 | JWT / Werkzeug 密码哈希 |
| 部署 | Docker / Docker Compose / Ubuntu Server |

## 功能范围

| 模块 | 功能说明 |
| --- | --- |
| 登录注册 | 支持手机号或邮箱登录，支持家长、学生、教师注册，默认测试密码为 `123456` |
| 角色首页 | 家长、学生、教师、领导进入不同工作台，展示适合角色的功能入口 |
| 通知公告 | 查看通知列表、通知详情，教师和领导可发布通知 |
| 作业管理 | 查看作业、布置作业、提交作业、教师评分 |
| 即时沟通 | 查看会话列表、选择联系人、创建或复用私聊会话、发送消息 |
| 考勤记录 | 查看学生出勤、迟到、请假、缺勤等记录 |
| 成绩报告 | 查看考试成绩报告和科目成绩详情 |
| 健康档案 | 查看体检、视力、身高体重、疫苗等健康记录 |
| 学生评价 | 查看评价记录，教师可写入评价 |
| 校园活动 | 查看活动列表和活动详情，支持报名相关接口 |
| 学校组织 | 查看学校信息、组织架构、班级学生名单 |
| 个人中心 | 查看个人资料、学校信息、组织架构并退出登录 |

## 项目结构

```text
.
├── AppScope/
│   ├── app.json5                         # 应用级配置，引用 App 名称和图标
│   └── resources/base/element/string.json # 应用名称资源
├── entry/
│   ├── src/main/module.json5             # HarmonyOS entry 模块配置
│   ├── src/main/ets/pages/               # ArkTS 页面
│   ├── src/main/ets/components/          # 公共组件、卡片、表单、工作台
│   ├── src/main/ets/services/            # 前端接口服务封装
│   ├── src/main/ets/models/              # 前端数据模型
│   ├── src/main/ets/store/               # 用户与应用状态
│   ├── src/main/ets/utils/               # 路由、日期、常量、存储工具
│   └── src/main/resources/               # 模块资源、网络配置、页面配置
├── backend/
│   ├── app/
│   │   ├── __init__.py                   # Flask 应用工厂、扩展初始化、异常处理
│   │   ├── config.py                     # 环境变量与应用配置
│   │   ├── extensions.py                 # SQLAlchemy / Migrate / CORS
│   │   ├── models.py                     # 数据库 ORM 模型
│   │   ├── routes.py                     # REST API 路由
│   │   ├── security.py                   # 密码哈希与 JWT 工具
│   │   └── seed.py                       # 初始化演示数据
│   ├── Dockerfile                        # Flask + Gunicorn 镜像封装
│   ├── requirements.txt                  # Python 依赖
│   └── wsgi.py                           # 后端启动入口
├── docs/assets/app_logo.png              # README 和 App 使用的 Logo 资源
└── docker-compose.yml                    # MySQL + Flask 一键部署配置
```

## 后端部署

推荐使用 Docker Compose 启动完整后端环境：

```bash
docker compose up -d --build
```

启动后可访问：

| 地址 | 说明 |
| --- | --- |
| `http://localhost:8080` | 后端健康入口 |
| `http://localhost:8080/api/notices` | 通知列表接口示例 |
| `localhost:3306` | MySQL 服务端口，默认数据库为 `hwadee_fsc` |

常用运维命令：

```bash
docker compose logs -f backend
docker compose logs -f mysql
docker compose down
docker compose down -v
```

生产环境建议：

- 修改默认数据库密码、`APP_SECRET_KEY` 和 `JWT_SECRET_KEY`。
- 使用 HTTPS 域名替代裸 IP。
- 将 MySQL 数据卷纳入服务器备份策略。
- 不要在公网暴露 MySQL 端口，除非已有安全组和访问控制。

## 后端配置

| 环境变量 | 说明 |
| --- | --- |
| `DATABASE_URL` | MySQL 连接串，例如 `mysql+pymysql://root:root@mysql:3306/hwadee_fsc?charset=utf8mb4` |
| `APP_SECRET_KEY` | Flask 应用密钥 |
| `JWT_SECRET_KEY` | JWT 签名密钥 |
| `AUTO_INIT_DB` | 是否在启动时自动建表并初始化演示数据，默认 `true` |
| `CORS_ORIGINS` | CORS 来源配置，开发环境可为 `*` |

本地 Python 方式运行后端：

```bash
cd backend
pip install -r requirements.txt
set DATABASE_URL=mysql+pymysql://root:root@127.0.0.1:3306/hwadee_fsc?charset=utf8mb4
python wsgi.py
```

Linux/macOS 可将 `set` 替换为：

```bash
export DATABASE_URL=mysql+pymysql://root:root@127.0.0.1:3306/hwadee_fsc?charset=utf8mb4
```

## DevEco 运行

1. 使用 DevEco Studio 打开仓库根目录。
2. 选择 `entry` 模块作为运行模块。
3. 确认前端当前使用真实后端接口：

```ts
// entry/src/main/ets/services/MockConfig.ets
export const USE_MOCK = false;
```

4. 确认后端地址配置为公网服务器：

```ts
// entry/src/main/ets/services/HttpUtil.ets
const BASE_URL = 'http://8.218.156.55:8080';
```

5. 在 DevEco Studio 中执行 Clean/Rebuild，然后 Run 到模拟器或真机。
6. 如果修改了桌面名称、图标或资源文件，建议先从模拟器卸载旧 App，再重新安装，避免旧 HAP 缓存影响显示。

当前命令行环境未提供 `hvigor`，因此完整 ArkTS 构建请以 DevEco Studio 的构建结果为准。

## 测试账号

初始化数据会写入以下账号，密码均为 `123456`：

| 角色 | 手机号 | 邮箱 | 说明 |
| --- | --- | --- | --- |
| 家长 | `13800000001` | `parent@huadee.test` | 家长工作台 |
| 学生 | `13800000002` | `student@huadee.test` | 学生工作台 |
| 教师 | `13800000003` | `teacher@huadee.test` | 教师工作台 |
| 领导 | `13800000004` | `leader@huadee.test` | 领导工作台 |

登录页也内置了快捷测试账号按钮，便于在模拟器中快速切换角色。

## 主要接口

统一响应结构：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

常用接口如下：

| 接口 | 方法 | 说明 |
| --- | --- | --- |
| `/api/auth/login` | POST | 登录，支持手机号或邮箱作为账号 |
| `/api/auth/register` | POST | 注册 |
| `/api/auth/logout` | POST | 退出登录 |
| `/api/users/profile` | GET / PUT | 当前用户资料查询与更新 |
| `/api/users/class/<class_id>` | GET | 班级学生列表 |
| `/api/users/contacts` | GET / POST | 联系人列表、添加联系人 |
| `/api/schools/<school_id>` | GET | 学校信息 |
| `/api/schools/<school_id>/org-tree` | GET | 学校组织架构 |
| `/api/notices` | GET / POST | 通知列表与发布通知 |
| `/api/notices/<notice_id>` | GET / PUT / DELETE | 通知详情、更新、删除 |
| `/api/homework` | GET / POST | 作业列表与布置作业 |
| `/api/homework/<homework_id>` | GET | 作业详情 |
| `/api/homework/<homework_id>/submit` | POST | 提交作业 |
| `/api/submissions/<submission_id>/grade` | PUT | 作业评分 |
| `/api/conversations` | GET / POST | 会话列表、创建或复用私聊会话 |
| `/api/conversations/<conversation_id>` | GET | 会话详情 |
| `/api/conversations/<conversation_id>/messages` | GET / POST | 消息列表与发送消息 |
| `/api/attendance/records` | GET | 考勤记录 |
| `/api/attendance/records/<record_id>` | GET | 考勤详情 |
| `/api/grades/reports` | GET | 成绩报告列表 |
| `/api/grades/reports/<report_id>` | GET | 成绩报告详情 |
| `/api/health/records` | GET | 健康档案列表 |
| `/api/health/records/<record_id>` | GET | 健康档案详情 |
| `/api/evaluations` | GET / POST | 学生评价列表与写评价 |
| `/api/evaluations/<evaluation_id>` | PUT | 更新学生评价 |
| `/api/activities` | GET | 校园活动列表 |
| `/api/activities/<activity_id>` | GET | 校园活动详情 |
| `/api/activities/<activity_id>/join` | POST | 活动报名 |
| `/api/activities/<activity_id>/comments` | POST | 活动评论 |

## 开发注意事项

- 前端页面应通过 `services/` 层访问接口，避免在页面中散落请求地址。
- 列表页需要对 `null`、`undefined`、空数组和接口失败做兜底，避免 ArkTS 运行时 TypeError 导致 App 闪退。
- 新增二级页面时应使用公共 `AppNavBar`，保证左上角返回行为一致。
- 主工作台模块图标应通过 `MobileWorkbench` 中的统一图标渲染方法维护，不要再使用单个蓝色汉字作为图标。
- 每次较大改动后需要更新本 README 的修改记录，并推送到 GitHub `main` 分支。

## 修改记录

### 2026-07-13

- Summary: 将图标系统从 ASCII 字符升级为 HarmonyOS SymbolGlyph 原生矢量图标。
- Changed: 重写 `ElementIcon` 组件，移除 `Text + glyph()` 的 ASCII 单字母渲染方式，改为 `SymbolGlyph($r('sys.symbol.xxx'))` 系统矢量图标组件；22 个语义图标名全部映射到 HarmonyOS 原生 Symbol 资源（`house_fill`、`message_fill`、`person_fill`、`bell_fill`、`square_and_pencil`、`doc_plaintext_fill_1`、`histogram`、`checkmark_circle_fill`、`heart_fill`、`star_fill`、`calendar`、`building_fill`、`person_2_fill`、`archivebox_fill`、`person_badge_plus`、`magnifyingglass`、`xmark`、`chevron_right`、`chevron_down`、`chevron_left`、`pin_fill`、`ohos_photo`）；使用 `SymbolRenderingStrategy.SINGLE` 单色渲染，保持蓝白简洁风格；API（`name`/`iconSize`/`color`）完全不变，29 处调用方零修改。
- Validation: DevEco Studio `assembleHap` 已通过（仅 1 WARN，无 ERROR）；`git diff --check` 通过。

### 2026-07-13

- Summary: 修复底部导航栏图标点击后颜色不跟随高亮的问题。
- Changed: `MobileWorkbench.ets` 中 `TabIcon` Builder 的 `active: boolean` 参数改为 `tabIndex: number`，在 Builder 内部直接引用 `this.currentTab === tabIndex` 计算激活态，解决 ArkTS `@Builder` 参数按值传递导致的响应式失效问题。
- Validation: 已在 DevEco Studio 中验证底部导航栏图标与文字颜色同步高亮/置灰。

### 2026-07-13

- Summary: 修复 DevEco/Hvigor ArkTS 编译报错，确认 `assembleHap` 构建通过。
- Changed: 将 `ElementIcon` 的 `size` 属性重命名为 `iconSize`，避免与 ArkUI 组件内置 `size()` 属性冲突；图标字符改为 ASCII 安全字符，规避特殊符号在 Windows/DevEco 编译链中的编码风险；为添加联系人请求体补充显式接口类型；个人信息保存 payload 改为逐字段构造，移除 ArkTS 不允许的对象展开。
- Validation: 已使用 DevEco Studio 自带 Node/Hvigor 执行 `assembleHap`，`CompileArkTS` 与 `PackageHap` 均通过，最终输出 `BUILD SUCCESSFUL`。

### 2026-07-13

- Summary: 全面复查功能页布局规范，并重构 App 图标体系为统一的 Element/Ant Design 风格语义图标层。
- Changed: 重写 `ElementIcon` 为 ArkTS 原生统一图标组件，采用 `Home`、`Message`、`User`、`Bell`、`Document`、`Chart`、`Calendar`、`School`、`Team`、`ChevronRight` 等常见 TypeScript 组件库语义命名；替换工作台、底部导航、公共返回栏、搜索框、表单选择器、日期选择器、图片选择器、通知/学生列表、活动卡片、组织架构和健康详情中的 `sys.symbol`、emoji、文本箭头和单字符占位图标；统一活动、成绩、作业、通知、健康等详情页为灰底页面 + 白色内容卡片布局，和列表页、表单页保持一致。
- Validation: 已执行 `git diff --check`，并确认 `entry/src/main/ets` 中不再存在 `sys.symbol`、emoji 图标和 `<` / `>` 文本箭头图标；当前命令行环境仍无 `hvigor`，最终 ArkTS 构建需在 DevEco Studio 中 Clean/Rebuild 验证。

### 2026-07-13

- Summary: 为联系人页面补充添加联系人能力，并接入后端持久化联系人关系。
- Changed: 新增后端 `Contact` 关联模型和 `POST /api/users/contacts` 接口，支持通过手机号、邮箱或用户ID添加联系人并避免重复关系；联系人列表接口兼容同校联系人和手动添加联系人；前端 `SelectContactPage` 增加可折叠添加联系人面板，保存成功后自动刷新列表；`UserService` 新增 `addContact` 服务方法，Mock 与真实后端模式均可调用。
- Validation: 已执行 `python -m compileall -f backend/app`、`git diff --check`，并使用 Flask testing 验证登录、添加联系人、重复添加、联系人列表和禁止添加自己均符合预期。

### 2026-07-13

- Summary: 同步个人信息编辑能力到 `main` 分支，并修正个人信息页主体布局为置顶展示。
- Changed: 将 `feature` 分支中的个人信息编辑、数据库同步、Element 风格图标和测试用例改动合入主分支；为 `PersonalProfilePage` 的根容器、滚动内容和资料区块增加显式顶部/左侧对齐，避免页面内容在个人信息页中呈现居中布局。
- Validation: 已确认保存链路为 `PersonalProfilePage.handleSave -> UserService.updateProfile -> PUT /api/users/profile -> UserStore.updateCurrentUser`，并执行 `git diff --check`。

### 2026-07-13

- Summary: 在 `feature` 分支优化主界面图标体系，重构个人信息页并补充功能测试用例。
- Changed: 新增 Element 风格语义图标组件 `ElementIcon`，主工作台模块和底部导航改为统一系统符号图标；个人信息页重构为资料概览、可编辑表单、组织信息和保存操作区，支持修改姓名、手机号、邮箱、任教学科、职务并调用 `/api/users/profile` 同步数据库；`UserStore` 新增当前用户资料同步方法；新增 `docs/TEST_CASES.md`，覆盖移动端冒烟、个人信息、主要功能页和后端接口测试用例。
- Validation: 已执行静态差异检查；当前命令行环境无 `hvigor`，需要在 DevEco Studio 中 Clean/Rebuild 后验证 ArkTS 构建、图标显示和个人资料保存流程。

### 2026-07-13

- Summary: 优化 App 主界面模块图标规范，去除蓝色单字作为图标的展示方式。
- Changed: 将 `MobileWorkbench` 中的功能模块和底部导航从 `首/讯/我/通/作/绩` 等单字标记改为语义化图标类型，并通过统一的 `WorkbenchIcon` 与 `TabIcon` 组件渲染；主界面功能卡片、消息/我的列表入口、底部导航栏统一使用图标容器、选中态色彩和固定尺寸，提升企业级移动端视觉一致性。
- Validation: 已执行静态搜索确认 `FeatureAction` / `TabAction` 不再使用 `mark` 字段；需在 DevEco Studio 中重新构建后查看模拟器实际视觉效果。

### 2026-07-13

- Summary: 修正 HarmonyOS 手机桌面显示名称。
- Changed: 将 `entry/src/main/resources/base/element/string.json` 中的 `EntryAbility_label` 从默认 `label` 改为 `家校通`，使安装到模拟器或真机后的桌面 App 名称显示为“家校通”。
- Validation: 已确认 `entry/src/main/module.json5` 的入口 Ability 仍引用 `$string:EntryAbility_label`，重新构建安装后桌面名称将使用新资源值。

### 2026-07-13

- Summary: 继续修复 DevEco 模拟器功能页闪退，补齐列表渲染层对 `null` 状态的兜底。
- Changed: 根据新崩溃日志 `GradeListPage.ets:32 Cannot read property length of null`，将成绩、活动、通知、我的发布、作业、聊天、会话、联系人、学生名单、考勤、健康、评价等列表页的 `.length`、`ForEach`、`.filter` 统一改为安全数组表达式；即使后端成功返回但 `data` 为 `null`，页面也展示空状态或空列表，不再触发 TypeError 闪退。
- Validation: 已执行 `git diff --check`；当前日志显示服务器 HTTP 访问成功，问题属于 ArkTS 运行时空数据防护，不是 `hvigor` 构建工具本身导致。当前环境仍无 `hvigor` 命令，需在 DevEco Studio 中 Clean/Rebuild 后重新安装验证。

### 2026-07-13

- Summary: 完善移动端页面返回导航，解决个人信息页和主页子栏目返回入口不明显的问题。
- Changed: 将公共 `AppNavBar` 的左上角返回控件改为明确的 `< 返回` 触控区，并扩大到 44px 高度；所有使用公共导航栏的通知、作业、活动、成绩、考勤、健康、评价、聊天、组织架构、个人信息等二级页面统一获得清晰返回入口；主页工作台的消息、我的、班级、发布等子栏目顶部增加返回首页按钮。
- Validation: 已执行 `git diff --check`，静态差异检查通过；当前环境无 `hvigor` 命令，需在 DevEco Studio 中重新构建并安装到模拟器验证实际触控体验。

### 2026-07-13

- Summary: 修复 DevEco 模拟器中进入功能页闪退的问题。
- Changed: 根据崩溃日志 `ActivityListPage.ets:42 Cannot read property length of undefined`，为活动、通知、我的发布、作业、消息、考勤、成绩、健康、评价、组织架构等页面增加接口返回兜底；当后端不可达或 `data/list` 为空时统一使用空数组或空状态展示，不再对 `undefined` 调用 `.length`、`.find`、`ForEach`；同时为成绩科目、评价标签、健康疫苗等数组字段增加兜底。
- Validation: 已执行 `git diff --check`；当前环境无 `hvigor` 命令，DevEco 模拟器需重新安装运行验证。
- Push: 本次修改推送到 `https://github.com/Chen-Jin-Han/Home-School-Communication-System` 的 `main` 分支。

### 2026-07-13

- Summary: 复核后端数据库功能完备性，补齐作业评分 JSON 写入兼容，并完成数据库读写验收。
- Changed: `/api/submissions/<id>/grade` 现在同时支持 JSON body 与 URL 参数，确保前端提交的 `score/comment` 能正确写入 `submission` 表；确认 MySQL Docker Compose 使用 `mysql_data` 持久化卷、后端等待 MySQL 健康检查、启动时自动建表和初始化数据。
- Database Review: 当前数据库模型覆盖学校、班级、用户、通知、作业、作业提交、会话、参与人、消息、活动、考勤、成绩、健康档案和学生评价；关键字段配置了主键、唯一约束或查询索引，JSON 字段通过序列化统一返回给前端。
- Validation: 已执行 `python -m compileall -f backend/app`、`docker compose config`，并使用 Flask testing 数据库完成初始化数据计数、登录、通知发布/详情、作业创建/提交/评分、个人资料更新、联系人列表、创建/复用会话、发送消息、评价创建、活动报名、学校信息、组织架构、班级学生、考勤、成绩和健康档案接口验收。
- Push: 本次修改推送到 `https://github.com/Chen-Jin-Han/Home-School-Communication-System` 的 `main` 分支。

### 2026-07-13

- Summary: 进行完整功能复查，修复真实后端模式下的列表分页、联系人、会话、学生名单、学校组织架构和初始化数据问题。
- Changed: 后端分页响应同时返回 `list` 与 `records`，兼容前端 `PageResult`；作业列表支持 `classId` 过滤，活动列表支持 `status` 过滤；新增 `/api/users/contacts` 和 `POST /api/conversations`，选择联系人可发起或复用私聊会话；重写初始化 seed 数据为可读中文，并补充会话、消息和活动样例；前端学生名单改为调用班级学生接口，联系人选择页改为真实联系人接口并接入聊天；学校信息与组织架构改为使用当前用户 `schoolId`，不再使用旧的 `s001`；`DateUtil` 兼容后端 ISO 时间字符串并修复中文时间文案。
- Validation: 已执行 `git diff --check`、`python -m compileall -f backend/app`，并使用 Flask testing 模式验证登录、通知分页、作业班级过滤、活动状态过滤、消息分页、学校信息、组织架构、班级学生、联系人列表和创建/复用私聊会话均返回成功。
- Push: 本次修改推送到 `https://github.com/Chen-Jin-Han/Home-School-Communication-System` 的 `main` 分支。

### 2026-07-13

- Summary: 重构 HarmonyOS ArkTS 前端为企业级移动端工作台规范，并复查主要功能入口、返回导航和表单状态逻辑。
- Changed: 统一 `Constants` 设计令牌，重构 `AppNavBar`、搜索、加载、空状态、错误态、表单输入、文本域、日期、选择器和评分组件；重写 `MobileWorkbench`，让家长、学生、教师、领导首页共享统一工作台；修复通知发布、布置作业、提交作业、写评价、搜索列表等页面的 `@Link` 双向绑定；恢复乱码中文文案；保留公网后端地址 `http://8.218.156.55:8080`。
- Function Review: 工作台入口覆盖通知、作业、成绩、考勤、健康、评价、活动、学校信息、组织架构、消息、发布通知、我的发布和个人信息；二级页面统一使用公共导航栏返回；后端补充会话详情、考勤详情、成绩详情、健康详情兼容接口。
- Validation: 已执行 `git diff --check`；当前环境未提供完整 DevEco Studio 图形构建链，最终 ArkTS 真机/模拟器构建请在 DevEco Studio 中运行。
- Push: 本次修改推送到 `https://github.com/Chen-Jin-Han/Home-School-Communication-System` 的 `main` 分支。

### 2026-07-13

- Summary: 修复 Ubuntu 服务器首次 Docker 部署时 Gunicorn 多 worker 并发初始化数据库导致的 MySQL DDL 冲突。
- Changed: `backend/Dockerfile` 中 Gunicorn 启动参数增加 `--preload`，让 Flask 应用和 `AUTO_INIT_DB` 初始化在 master 进程完成后再 fork worker。
- Push: 已推送到 `main` 分支。

### 2026-07-13

- Summary: 新增零成本邮箱登录方案，并重构 HarmonyOS ArkTS 首页为移动端 App 工作台布局。
- Changed: 后端 `User` 模型新增 `email` 字段，`/api/auth/login` 支持手机号/邮箱统一账号登录；前端更新登录页、注册页、用户模型和首页工作台。
- Push: 已推送到 `main` 分支。

### 2026-07-13

- Summary: 将后端从 Spring Boot 迁移为 Flask + MySQL 架构，并完成 Docker Compose 部署封装。
- Changed: 新增 Flask 应用工厂、SQLAlchemy ORM、JWT 鉴权、统一响应和异常处理、MySQL 初始化数据、Gunicorn 部署入口。
- Push: 已推送到 `main` 分支。
