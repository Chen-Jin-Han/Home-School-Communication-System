## 后端运行指南

### 前置条件
- Java 21（已安装 ✓）
- Maven 3.9+
- MySQL 8.4（已安装 ✓，暂不需要，默认使用 H2 内存数据库）

### 第一步：安装 Maven

**方法1：手动下载（推荐）**

1. 浏览器打开 https://maven.apache.org/download.cgi
2. 下载 `apache-maven-3.9.6-bin.zip`
3. 解压到 `D:\maven`
4. 添加环境变量：`D:\maven\apache-maven-3.9.6\bin` 到 PATH
5. 验证：`mvn -version`

**方法2：IntelliJ IDEA**
如果你有 IntelliJ IDEA，它自带 Maven，直接右键 `pom.xml` → Maven → Reload Project。

### 第二步：启动后端

```bash
cd backend
mvn spring-boot:run
```

首次运行会自动下载依赖（阿里云镜像加速已配置），约 1-2 分钟。

### 第三步：验证

- **API 文档**: http://localhost:8080/doc.html
- **H2 控制台**: http://localhost:8080/h2-console（JDBC URL: `jdbc:h2:mem:hwadee_fsc`）

### 测试

```bash
curl http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d "{\"phone\":\"13800000001\",\"password\":\"123456\"}"
```

### 切换到 MySQL（生产环境）

```bash
mvn spring-boot:run -Dspring.profiles.active=mysql
```

需要先创建数据库：
```sql
CREATE DATABASE hwadee_fsc DEFAULT CHARACTER SET utf8mb4;
```
