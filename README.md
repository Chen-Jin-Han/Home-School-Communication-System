# Home-School Communication System

<div align="center">
  <img src="./docs/assets/app_logo.png" alt="家校通 华迪 HuaDee Logo" width="180">
  <br>
  <strong>家校通 · 华迪 HuaDee</strong>
</div>

家校通是一套面向家长、学生、教师和学校领导的家校沟通系统，包含 HarmonyOS ArkTS 移动端和 Flask 企业级后端。系统提供通知公告、作业、考勤、成绩、健康档案、学生评价、即时沟通、校园活动、组织架构和学校信息等能力。

## 技术栈

| 模块 | 技术 |
| --- | --- |
| 移动端 | HarmonyOS / ArkTS / ArkUI / Hvigor |
| 后端 | Flask 3 / SQLAlchemy / Gunicorn |
| 数据库 | MySQL 8.x |
| 鉴权 | JWT |
| 部署 | Docker / Docker Compose |

## 项目结构

```text
.
├── entry/                         # HarmonyOS ArkTS 客户端
├── backend/                       # Flask 后端
│   ├── app/
│   │   ├── __init__.py            # 应用工厂、扩展初始化、异常处理
│   │   ├── config.py              # 环境配置
│   │   ├── extensions.py          # SQLAlchemy / Migrate / CORS
│   │   ├── models.py              # ORM 模型
│   │   ├── routes.py              # REST API
│   │   ├── security.py            # 密码哈希与 JWT
│   │   └── seed.py                # 初始化数据
│   ├── Dockerfile
│   ├── requirements.txt
│   └── wsgi.py
├── docs/assets/app_logo.png       # README 展示 Logo
└── docker-compose.yml             # MySQL + Flask 一键启动
```

## 快速部署

推荐使用 Docker Compose，本地和 Ubuntu 服务器部署方式一致：

```bash
docker compose up -d --build
```

启动后访问：

| 地址 | 说明 |
| --- | --- |
| `http://localhost:8080` | 后端健康入口 |
| `http://localhost:8080/api/notices` | 通知接口示例 |
| `localhost:3306` | MySQL，默认库名 `hwadee_fsc` |

常用运维命令：

```bash
docker compose logs -f backend
docker compose down
docker compose down -v
```

## 后端配置

生产环境务必修改默认密钥和数据库密码。

| 环境变量 | 说明 |
| --- | --- |
| `DATABASE_URL` | MySQL 连接串，例如 `mysql+pymysql://root:root@mysql:3306/hwadee_fsc?charset=utf8mb4` |
| `APP_SECRET_KEY` | Flask 应用密钥 |
| `JWT_SECRET_KEY` | JWT 签名密钥 |
| `AUTO_INIT_DB` | 是否启动时自动建表和初始化数据，默认 `true` |
| `CORS_ORIGINS` | CORS 来源，默认 `*` |

本地 Python 运行：

```bash
cd backend
pip install -r requirements.txt
set DATABASE_URL=mysql+pymysql://root:root@127.0.0.1:3306/hwadee_fsc?charset=utf8mb4
python wsgi.py
```

## DevEco 运行

1. 使用 DevEco Studio 打开仓库根目录。
2. 确认 `entry/src/main/ets/services/MockConfig.ets` 为：

```ts
export const USE_MOCK = false;
```

3. 确认 `entry/src/main/ets/services/HttpUtil.ets` 后端地址为：

```ts
const BASE_URL = 'http://8.218.156.55:8080';
```

4. 在 DevEco 中选择 `entry` 模块，启动预览器、模拟器或真机调试。

如果后端部署在公网服务器，DevEco 模拟器和真机可以直接访问公网 IP。生产环境建议使用 HTTPS 域名。

## 测试账号

初始化数据会写入以下账号，密码均为 `123456`：

| 角色 | 手机号 | 邮箱 | 说明 |
| --- | --- | --- | --- |
| 家长 | `13800000001` | `parent@huadee.test` | 家长端首页 |
| 学生 | `13800000002` | `student@huadee.test` | 学生端首页 |
| 教师 | `13800000003` | `teacher@huadee.test` | 教师端首页 |
| 领导 | `13800000004` | `leader@huadee.test` | 领导端首页 |

## 主要接口

| 接口 | 方法 | 说明 |
| --- | --- | --- |
| `/api/auth/login` | POST | 登录 |
| `/api/auth/register` | POST | 注册 |
| `/api/notices` | GET | 通知列表 |
| `/api/homework` | GET | 作业列表 |
| `/api/conversations` | GET | 会话列表 |
| `/api/attendance/records` | GET | 考勤记录 |
| `/api/grades/reports` | GET | 成绩报告 |
| `/api/health/records` | GET | 健康记录 |
| `/api/evaluations` | GET | 学生评价 |
| `/api/activities` | GET | 活动列表 |

统一响应格式：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

## 修改记录

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
