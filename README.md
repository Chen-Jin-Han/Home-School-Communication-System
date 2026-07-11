# Home-School Communication System

<div align="center">
  <img src="./docs/assets/app_logo.png" alt="家校通 华迪 HuaDee Logo" width="180">
  <br>
  <strong>家校通 · 华迪 HuaDee</strong>
</div>

家校沟通系统，包含 HarmonyOS 客户端和 Spring Boot 后端。系统面向家长、学生、教师和学校领导，提供通知公告、作业、考勤、成绩、健康、评价、聊天和学校信息等功能。

## 技术栈

| 模块 | 技术 |
| --- | --- |
| 移动端 | HarmonyOS / ArkTS / ArkUI / Hvigor |
| 后端 | Spring Boot 3.2.0 / Java 17 / Maven |
| 数据访问 | MyBatis-Plus 3.5.5 |
| 鉴权 | Spring Security / JWT |
| 数据库 | MySQL 8.x，开发时也可使用 H2 |
| API 文档 | Knife4j |
| 容器化 | Docker / Docker Compose |

## 项目结构

```text
.
├── entry/                         # HarmonyOS ArkTS 客户端
│   └── src/main/ets/
│       ├── components/            # 通用组件、卡片、表单、列表
│       ├── mock/                  # Mock 数据
│       ├── models/                # 前端数据模型
│       ├── pages/                 # 登录、首页、通知、作业等页面
│       ├── services/              # Mock/HTTP 服务封装
│       ├── store/                 # 应用状态
│       └── utils/                 # 工具类
├── backend/                       # Spring Boot 后端
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/hwadee/fsc/
│       │   ├── common/            # 统一响应、分页、异常处理
│       │   ├── config/            # Security、CORS、MyBatis、Knife4j 配置
│       │   ├── controller/        # REST API
│       │   ├── dto/               # 请求 DTO
│       │   ├── entity/            # 数据实体
│       │   ├── mapper/            # MyBatis-Plus Mapper
│       │   ├── security/          # JWT 认证
│       │   └── service/           # 业务服务
│       └── resources/
│           ├── application.yml
│           ├── application-dev.yml
│           ├── application-mysql.yml
│           └── db/migration/      # 初始化 SQL
└── docker-compose.yml             # MySQL + 后端一键启动
```

## 快速启动

### 方式一：Docker Compose

推荐本地联调使用这一方式。它会启动 MySQL 8.0 和后端服务，并自动初始化数据库。

```bash
docker compose up -d --build
```

启动后访问：

| 地址 | 说明 |
| --- | --- |
| http://localhost:8080/doc.html | Knife4j API 文档 |
| http://localhost:8080 | 后端服务根地址 |
| localhost:3306 | MySQL，账号 `root`，密码 `root`，库名 `hwadee_fsc` |

查看日志：

```bash
docker compose logs -f backend
```

停止服务：

```bash
docker compose down
```

如需同时删除本地数据库卷：

```bash
docker compose down -v
```

### 方式二：本机 Java 运行

环境要求：

- JDK 17
- Maven 3.9+，或使用 `backend/mvnw.cmd`
- MySQL 8.x，默认连接 `root/root@localhost:3306/hwadee_fsc`

启动 MySQL 后运行：

```bash
cd backend
mvn spring-boot:run -Dspring-boot.run.profiles=mysql
```

没有安装 Maven 时可使用：

```bash
cd backend
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=mysql
```

开发时也可以使用 H2 内存数据库：

```bash
cd backend
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

H2 控制台地址：

```text
http://localhost:8080/h2-console
```

## 后端配置

默认配置文件为 `backend/src/main/resources/application.yml`，当前默认激活 `mysql` profile。

MySQL 连接支持环境变量覆盖：

| 环境变量 | 默认值 |
| --- | --- |
| `SPRING_DATASOURCE_URL` | `jdbc:mysql://localhost:3306/hwadee_fsc?...` |
| `SPRING_DATASOURCE_USERNAME` | `root` |
| `SPRING_DATASOURCE_PASSWORD` | `root` |

Docker Compose 中后端会连接服务名为 `mysql` 的数据库容器：

```yaml
SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/hwadee_fsc?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useSSL=false
```

## HarmonyOS 客户端联调

1. 使用 DevEco Studio 打开仓库根目录。
2. 在 `entry/src/main/ets/services/MockConfig.ets` 中切换数据源：

```ts
export const USE_MOCK = false;
```

3. 在 `entry/src/main/ets/services/HttpUtil.ets` 中确认后端地址。当前为：

```ts
const BASE_URL = 'http://192.168.54.60:8080';
```

如果在模拟器或真机上访问本机后端，需要将该地址改为电脑在同一局域网中的 IP，例如：

```ts
const BASE_URL = 'http://192.168.1.100:8080';
```

4. 连接模拟器或真机，点击 Run。

客户端已在 `entry/src/main/module.json5` 配置网络权限和明文 HTTP 网络访问配置，网络配置文件位于：

```text
entry/src/main/resources/base/profile/network_config.json
```

## 测试账号

数据库初始化 SQL 会写入以下账号，密码均为 `123456`：

| 角色 | 手机号 | 说明 |
| --- | --- | --- |
| 家长 | `13800000001` | 家长端首页 |
| 学生 | `13800000002` | 学生端首页 |
| 教师 | `13800000003` | 教师端首页 |
| 领导 | `13800000004` | 领导端首页 |

## 常用接口

| 接口 | 方法 | 说明 |
| --- | --- | --- |
| `/api/auth/login` | POST | 登录 |
| `/api/auth/register` | POST | 注册 |
| `/api/notices` | GET | 通知列表 |
| `/api/homework` | GET | 作业列表 |
| `/api/attendance` | GET | 考勤记录 |
| `/api/grades` | GET | 成绩报告 |
| `/api/health` | GET | 健康记录 |
| `/api/evaluations` | GET | 学生评价 |

完整接口请访问 `http://localhost:8080/doc.html`。

## 本次合并说明

- 已将 `harmonyos-app` 分支内容合并到 `main`。
- 合并时两个分支没有共同历史，使用了 `--allow-unrelated-histories` 并以 `harmonyos-app` 中完整客户端和后端实现为准处理冲突。
- 新增后端 Dockerfile、根目录 `docker-compose.yml` 和 `.dockerignore`。
- 将 MySQL 连接改为环境变量可覆盖，便于本机和容器部署。
- 移除了合并带入的本地配置文件和无说明二进制文档，避免污染主分支。
