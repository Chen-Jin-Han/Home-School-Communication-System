# Home-School Communication System

<div align="center">
  <img src="./docs/assets/app_logo.png" alt="家校通 华迪 HuaDee Logo" width="180">
  <br>
  <strong>家校通 · 华迪 HuaDee</strong>
</div>

家校沟通系统，包含 HarmonyOS 客户端和 Flask 企业级后端。系统面向家长、学生、教师和学校领导，提供通知公告、作业、考勤、成绩、健康、评价、聊天和学校信息等功能。

## 技术栈

| 模块 | 技术 |
| --- | --- |
| 移动端 | HarmonyOS / ArkTS / ArkUI / Hvigor |
| 后端 | Flask 3 / SQLAlchemy / Gunicorn |
| 数据库 | MySQL 8.x |
| 鉴权 | JWT |
| 运维 | Docker / Docker Compose |

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
└── docker-compose.yml             # MySQL + Flask 后端一键启动
```

## 快速启动

推荐使用 Docker Compose，本地和服务器部署配置一致：

```bash
docker compose up -d --build
```

启动后访问：

| 地址 | 说明 |
| --- | --- |
| http://localhost:8080 | 后端健康入口 |
| http://localhost:8080/doc.html | 后端接口说明入口 |
| localhost:3306 | MySQL，账号 `root`，密码 `root`，库名 `hwadee_fsc` |

查看日志：

```bash
docker compose logs -f backend
```

停止服务：

```bash
docker compose down
```

同时删除数据库卷：

```bash
docker compose down -v
```

## 后端配置

后端通过环境变量配置，生产环境必须修改密钥。

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

## HarmonyOS 客户端联调

1. 使用 DevEco Studio 打开仓库根目录。
2. 在 `entry/src/main/ets/services/MockConfig.ets` 中关闭 Mock：

```ts
export const USE_MOCK = false;
```

3. 在 `entry/src/main/ets/services/HttpUtil.ets` 中配置后端地址：

```ts
const BASE_URL = 'http://你的服务器IP:8080';
```

如果后端部署在公网服务器，DevEco 模拟器和真机都可以直接访问该公网地址。生产环境建议使用 HTTPS 域名。

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

响应格式统一为：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

## 本次后端迁移说明

- 后端已从 Spring Boot 迁移为 Flask。
- 删除旧 Maven / Java 后端构建文件，避免两套后端并存。
- 使用 SQLAlchemy ORM 管理 MySQL 数据模型。
- 使用 JWT 做登录态，保留前端现有 `Authorization: Bearer <token>` 调用方式。
- 保留原 `/api/...` 路由，尽量兼容现有 HarmonyOS 客户端。
- Docker Compose 已切换为 Flask + MySQL 部署方式。

## 修改记录

### 2026-07-13

- Summary: 将后端从 Spring Boot 迁移为企业级 Flask + MySQL 架构，并完成 Docker Compose 验证。
- Changed: 替换 `backend/` 为 Flask 应用工厂、SQLAlchemy ORM、JWT 鉴权、统一响应/异常处理、MySQL 初始化数据和 Gunicorn 部署入口；同步更新 `docker-compose.yml`、`backend/Dockerfile`、`README.md` 和 `backend/README.md`。
- Validation: 已执行 Python 编译检查、Flask testing 模式接口冒烟、`docker compose config`、`docker build`、`docker compose up -d --build`，并验证容器环境下 `/`、`/api/notices`、`/api/auth/login`、`/api/users/profile` 返回成功。
- Push: 已推送到 `https://github.com/Chen-Jin-Han/Home-School-Communication-System` 的 `main` 分支。

### 2026-07-13

- Summary: 前后端新增零成本邮箱登录方案，并重构 HarmonyOS ArkTS 前端为移动端 App 工作台布局。
- Changed: 后端 `User` 模型新增 `email` 字段，`/api/auth/login` 支持手机号/邮箱统一账号登录，注册接口支持手机号或邮箱至少填写一个；启动初始化加入旧 MySQL 表补列逻辑。前端更新 `UserModel`、`AuthService`、`MockAuth`、登录页、注册页和启动页，并新增 `MobileWorkbench` 共享组件，家长/学生/教师/领导首页统一复用移动端工作台，保留通知、作业、成绩、考勤、健康、评价、活动、发布、组织架构、聊天和个人中心等入口。
- Validation: 已执行 `git diff --check`、`python -m compileall backend/app`，并用 Flask testing 模式验证邮箱登录、手机号登录、仅邮箱注册和注册后邮箱登录成功；当前本机 PATH 未提供 `hvigor` / `ohpm`，前端完整 DevEco 构建需在 DevEco Studio 中执行。
- Push: 本次修改将推送到 `https://github.com/Chen-Jin-Han/Home-School-Communication-System` 的 `main` 分支。


