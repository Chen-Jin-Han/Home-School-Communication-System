# 家校通 Hwadee-FSC

家校互通平台 HarmonyOS 客户端，为家长、学生、教师、校领导提供便捷、实时、准确的沟通方式。

## 技术栈

| 层 | 技术 |
|---|------|
| 平台 | HarmonyOS (API 6.1.1 / SDK 24) |
| 语言 | ArkTS |
| UI | ArkUI 声明式开发 |
| 构建 | Hvigor |
| 测试 | @ohos/hypium + @ohos/hamock |

## 快速开始

### 环境要求

- DevEco Studio (API 6.1.1+)
- HarmonyOS SDK 24

### 克隆项目

```bash
git clone -b harmonyos-app https://github.com/Chen-Jin-Han/Home-School-Communication-System.git
```

用 DevEco Studio 打开项目目录，连接模拟器或真机，点击 Run 即可。

### 测试账号

| 角色 | 手机号 | 密码 |
|------|--------|------|
| 家长 (张伟) | 13800000001 | 123456 |
| 学生 (张小伟) | 13800000002 | 123456 |
| 教师 (李老师) | 13800000003 | 123456 |
| 领导 (王校长) | 13800000004 | 123456 |

## 项目架构

```
entry/src/main/ets/
├── pages/                    # 页面
│   ├── Index.ets             # 闪屏
│   ├── LoginPage.ets         # 登录
│   ├── home/                 # 4个角色首页 (Tab导航)
│   ├── school/               # 学校微网站
│   ├── user/                 # 用户管理
│   ├── publish/              # 信息发布
│   ├── chat/                 # 交流互动
│   ├── homework/             # 课后作业
│   ├── activity/             # 学生活动
│   ├── attendance/           # 学生考勤
│   ├── grade/                # 学生成绩
│   ├── health/               # 学生健康
│   └── evaluation/           # 学生评价
├── components/
│   ├── common/               # 通用组件 (导航栏/头像/权限门控等)
│   ├── card/                 # 卡片组件
│   ├── list/                 # 列表项组件
│   └── form/                 # 表单组件
├── models/                   # 数据模型 (10个)
├── services/                 # API 服务层 (12个, Mock实现)
├── mock/                     # Mock 数据
├── store/                    # 状态管理
└── utils/                    # 工具类
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

## 切换真实后端

编辑 `entry/src/main/ets/services/MockConfig.ets`，将 `USE_MOCK` 改为 `false`，然后在各 Service 中实现真实 HTTP 请求：

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
hvigorw assembleHap
```
