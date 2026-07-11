# 家校通 Hwadee-FSC

家校互通平台，为家长、学生、教师、校领导提供便捷、实时、准确的沟通方式。HarmonyOS 客户端 + SpringBoot 后端，支持前后端联调。

## 技术栈

| 层 | 技术 |
|---|------|
| 前端平台 | HarmonyOS (API 6.1.1 / SDK 24) |
| 前端语言 | ArkTS |
| 前端 UI | ArkUI 声明式开发 |
| 前端构建 | Hvigor |
| 后端框架 | Spring Boot 3.2.0 + Java 21 |
| 后端 ORM | MyBatis-Plus 3.5.5 |
| 后端鉴权 | Spring Security + JWT |
| 数据库 | MySQL 8.4 (生产) / H2 (开发) |
| API 文档 | Knife4j (Swagger) |
| 构建 | Maven 3.9+ |

## 快速开始

### 环境要求

- DevEco Studio (API 6.1.1+)
- Java 21
- Maven 3.9+
- MySQL 8.4 (密码 root)

### 克隆项目

```bash
git clone -b harmonyos-app https://github.com/Chen-Jin-Han/Home-School-Communication-System.git
```

### 前端

用 DevEco Studio 打开项目目录，连接模拟器或真机，点击 Run。

前端支持 Mock / 真实 HTTP 双模式：编辑 `entry/src/main/ets/services/MockConfig.ets` 切换 `USE_MOCK`。

### 后端

```bash
cd backend

# 开发环境 (H2 内存数据库，零配置)
mvn spring-boot:run -Dspring.profiles.active=dev

# 生产环境 (MySQL)
mvn spring-boot:run -Dspring.profiles.active=mysql
```

启动后访问：

| 地址 | 说明 |
|------|------|
| http://localhost:8080/doc.html | API 文档 + 在线调试 |
| http://localhost:8080/h2-console | H2 控制台（仅 dev 模式） |

### 测试账号

| 角色 | 手机号 | 密码 |
|------|--------|------|
| 家长 (张伟) | 13800000001 | 123456 |
| 学生 (张小伟) | 13800000002 | 123456 |
| 教师 (李老师) | 13800000003 | 123456 |
| 领导 (王校长) | 13800000004 | 123456 |

### MySQL 数据库

```bash
# 命令行连接
& "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" -u root -proot hwadee_fsc
```

## 项目架构

```
├── entry/src/main/ets/        # 前端 (HarmonyOS ArkTS)
│   ├── pages/                 # 页面 (登录/注册/首页/微网站/用户/消息/作业/活动/考勤/成绩/健康/评价)
│   ├── components/            # 通用组件 (导航栏/头像/权限门控/卡片/列表/表单)
│   ├── models/                # 数据模型
│   ├── services/              # API 服务层 (Mock + 真实 HTTP 双模式)
│   ├── store/                 # 状态管理 (UserStore/AppStore)
│   └── utils/                 # 工具类
│
└── backend/                   # 后端 (SpringBoot)
    └── src/main/java/com/hwadee/fsc/
        ├── controller/        # REST 控制器 (11个)
        ├── entity/            # 实体类 (14个)
        ├── mapper/            # MyBatis-Plus Mapper
        ├── service/           # 业务服务
        ├── security/          # JWT 认证
        ├── config/            # 安全/CORS/MyBatis 配置
        └── common/            # 统一响应/异常处理/分页
```

## 功能模块

| 模块 | 功能 |
|------|------|
| 登录注册 | 手机号+密码登录，JWT 认证，新用户注册 |
| 学校微网站 | 学校信息、通知公告列表/详情 |
| 用户管理 | 个人信息、组织架构、学生名单 |
| 信息发布 | 教师/领导发布通知公告 |
| 交流互动 | 会话列表、聊天 |
| 课后作业 | 作业列表/详情、布置作业、提交作业 |
| 学生活动 | 活动列表/详情 |
| 学生考勤 | 月度考勤记录、考勤统计 |
| 学生成绩 | 成绩报告列表、科目明细 |
| 学生健康 | 体检记录、疫苗接种 |
| 学生评价 | 评价列表、教师写评价 |

## 角色权限

- **家长**: 查看子女考勤/通知/作业/成绩/健康/评价
- **学生**: 查看通知/作业/成绩/考勤/评价，提交作业
- **教师**: 发布通知、布置作业、写评价、查看班级信息
- **领导**: 发布通知/新闻、查看全校统计、管理组织架构
