# Hwadee FSC Flask Backend

企业级 Flask 后端实现，使用 Flask 应用工厂、SQLAlchemy ORM、JWT 鉴权、统一响应、统一异常处理和 MySQL 持久化。

## 技术栈

- Flask 3
- Flask-SQLAlchemy
- Flask-Migrate / Alembic
- PyMySQL
- PyJWT
- Gunicorn
- MySQL 8.x

## 环境变量

| 变量 | 说明 |
| --- | --- |
| `DATABASE_URL` | MySQL 连接串，例如 `mysql+pymysql://root:root@mysql:3306/hwadee_fsc?charset=utf8mb4` |
| `JWT_SECRET_KEY` | JWT 签名密钥，生产环境必须修改 |
| `APP_SECRET_KEY` | Flask 应用密钥，生产环境必须修改 |
| `AUTO_INIT_DB` | 是否启动时自动建表和初始化种子数据，默认 `true` |
| `CORS_ORIGINS` | CORS 来源，默认 `*` |

## 本地运行

```bash
pip install -r requirements.txt
set FLASK_ENV=development
set DATABASE_URL=mysql+pymysql://root:root@127.0.0.1:3306/hwadee_fsc?charset=utf8mb4
python wsgi.py
```

服务默认监听 `8080`。

## Docker 运行

在仓库根目录执行：

```bash
docker compose up -d --build
```

Compose 会启动 MySQL 和 Flask 后端，后端通过 `DATABASE_URL` 连接 MySQL。

## 接口兼容

Flask 后端保留原 HarmonyOS 客户端使用的接口路径，例如：

- `POST /api/auth/login`
- `GET /api/notices`
- `GET /api/homework`
- `GET /api/users/profile`
- `GET /api/schools/1`
- `GET /api/attendance/records`
- `GET /api/grades/reports`
- `GET /api/health/records`
- `GET /api/evaluations`

响应格式统一为：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```
