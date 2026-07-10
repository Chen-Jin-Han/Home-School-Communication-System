# 家校通 Hwadee-FSC

家校互通平台，为家长、学生、教师、校领导提供便捷、实时、准确的沟通方式。HarmonyOS 客户端 + SpringBoot 后端，支持前后端联调。

## 技术栈

| 层 | 技术 |
|---|------|
| 前端平台 | HarmonyOS (API 6.1.1 / SDK 24) |
| 前端语言 | ArkTS |
| 前端 UI | ArkUI 声明式开发 |
| 前端构建 | Hvigor |
| 前端测试 | @ohos/hypium + @ohos/hamock |
| 后端框架 | Spring Boot 3.2.0 (Java 17) |
| 后端 ORM | MyBatis-Plus 3.5.5 |
| 后端鉴权 | Spring Security + JWT (jjwt 0.12.3) |
| 后端数据库 | H2 (开发) / MySQL 8.4 (生产) |
| 后端 API 文档 | Knife4j (Swagger) |
| 后端构建 | Maven 3.9+ |

## 快速开始

### 前端

**环境要求**: DevEco Studio (API 6.1.1+), HarmonyOS SDK 24

```bash
git clone https://github.com/Chen-Jin-Han/Home-School-Communication-System.git
```

用 DevEco Studio 打开项目目录，连接模拟器或真机，点击 Run 即可。

### 后端

详见 [backend/SETUP.md](backend/SETUP.md)。

```bash
cd backend
mvn spring-boot:run
```

首次运行自动下载依赖（阿里云镜像加速已配置）。启动后访问：
- API 文档: http://localhost:8080/doc.html
- H2 控制台: http://localhost:8080/h2-console（JDBC URL: `jdbc:h2:mem:hwadee_fsc`）

### 测试账号

| 角色 | 手机号 | 密码 |
|------|--------|------|
| 家长 (张伟) | 13800000001 | 123456 |
| 学生 (张小伟) | 13800000002 | 123456 |
| 教师 (李老师) | 13800000003 | 123456 |
| 领导 (王校长) | 13800000004 | 123456 |

## 项目架构

```
├── entry/src/main/ets/        # 前端 (HarmonyOS ArkTS)
│   ├── pages/                 # 页面 (登录/首页/微网站/用户/发布/聊天/作业/活动/考勤/成绩/健康/评价)
│   ├── components/            # 通用组件 (导航栏/头像/权限门控/卡片/列表/表单)
│   ├── models/                # 数据模型
│   ├── services/              # API 服务层 (真实 HTTP + Mock 双模式)
│   ├── mock/                  # Mock 数据
│   ├── store/                 # 状态管理
│   └── utils/                 # 工具类
│
└── backend/                   # 后端 (SpringBoot)
    └── src/main/java/com/hwadee/fsc/
        ├── controller/        # REST 控制器 (11个)
        ├── entity/            # 实体类 (14个)
        ├── mapper/            # MyBatis-Plus Mapper
        ├── dto/               # 请求/响应 DTO
        ├── config/            # 安全/CORS/MyBatis/Knife4j 配置
        ├── common/            # 统一响应/异常处理/分页
        └── FscApplication.java
```

## 功能模块

| 模块 | 功能 |
|------|------|
| 学校微网站 | 学校信息、通知公告列表/详情 |
| 用户管理 | 个人信息、组织架构、学生名单 |
| 信息发布 | 教师/领导发布通知公告 |
| 交流互动 | 会话列表、聊天、联系人选择 |
| 课后作业 | 作业列表/详情、布置作业、提交作业 |
| 学生活动 | 活动列表/详情、报名参与 |
| 学生考勤 | 月度考勤记录、考勤统计 |
| 学生成绩 | 成绩报告列表、科目明细及趋势 |
| 学生健康 | 体检记录、疫苗接种、健康趋势 |
| 学生评价 | 评价列表、教师写评价(星级+标签) |

## 角色权限

使用 RBAC 模型，`PermissionGate` 组件控制功能入口：

- **家长**: 查看子女考勤/通知/作业/成绩/健康/评价
- **学生**: 查看通知/作业/成绩/考勤/评价，提交作业
- **教师**: 发布通知、布置作业、写评价、查看班级信息
- **领导**: 发布通知/新闻、查看全校统计、管理组织架构

## 前后端联调

前端支持 Mock / 真实 HTTP 双模式切换。编辑 `entry/src/main/ets/services/MockConfig.ets`，将 `USE_MOCK` 改为 `false` 即可连接后端：

```typescript
import { http } from '@kit.NetworkKit';

const req = http.createHttp();
const resp = await req.request(`${BASE_URL}/api/auth/login`, {
  method: http.RequestMethod.POST,
  header: { 'Content-Type': 'application/json' },
  extraData: JSON.stringify(params),
});
```

## 构建

```bash
# 前端
hvigorw assembleHap

# 后端
cd backend && mvn package -DskipTests
```
