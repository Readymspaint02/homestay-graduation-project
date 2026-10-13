<div align="center">

# 🏠 民宿短租管理系统

基于 **Spring Boot 3 + Vue 3** 的前后端分离民宿预订平台，覆盖「浏览房源 → 在线预订 → 支付 → 入住 → 评价」完整业务闭环。

</div>

## 📺 项目演示视频

[B站讲解视频：民宿短租系统演示](https://www.bilibili.com/video/BV1zGp96VEfR/)

---

## ✨ 项目介绍

本系统是一个面向民宿短租场景的综合性预订平台，包含 **用户端（C 端）**、**房东工作台**、**保洁员端** 和 **管理后台** 四类角色入口，实现了多角色协同的民宿运营管理闭环。

### 核心功能

| 模块 | 功能说明 |
|------|----------|
| 🏡 房源管理 | 房源发布、多图展示、设施标签、分类、上下架、审核 |
| 📅 日历房态 | 房间价格日历、可订/停售状态管理、房态冲突校验 |
| 📝 订单系统 | 在线预订、支付宝沙箱支付、订单状态流转、超时自动取消 |
| ⭐ 评价体系 | 用户评价、评分、评论回复、评价审核 |
| 🧹 保洁任务 | 退房自动生成保洁任务、保洁员接单/完成 |
| 💬 即时通讯 | WebSocket 在线聊天（用户↔房东）、SSE 消息推送 |
| 🤖 AI 助手 | 基于 DeepSeek 的智能客服与房源推荐 |
| 🔔 监督巡检 | 平台巡检报告、违规上报 |
| 👑 管理后台 | 若依权限体系：用户/角色/菜单/字典、操作日志、定时任务 |

### 技术栈

**后端**

- Java 17 · Spring Boot 3.5 · Spring Security · MyBatis-Plus
- MySQL 8 · Redis · Druid 连接池
- JWT 认证 · Sa-Token 风格 Token 服务
- Quartz 定时任务 · WebSocket · SSE
- 支付宝沙箱支付 · 七牛云对象存储 · DeepSeek AI
- RuoYi-Vue 3.9.1（若依框架）

**前端**

| 端 | 技术栈 | 端口 |
|----|--------|------|
| `homestay-client`（用户端） | Vue 3 + TypeScript + Ant Design Vue + Pinia + Vite | 3000 |
| `homestay-admin`（管理后台） | Vue 3 + Element Plus + Pinia + ECharts + Vite | 81 |

---

## 📁 项目结构

```
homestay-graduation-project/
├── 数据库/
│   └── homestay.sql              # 完整建库脚本（业务表 + 若依框架表）
└── 项目源代码/
    ├── homestay-server/          # 后端服务（Spring Boot 多模块 Maven 项目）
    │   ├── ruoyi-admin/          # 启动模块 / 配置 / 入口
    │   ├── ruoyi-biz/            # 民宿业务模块（核心业务代码）
    │   ├── ruoyi-common/         # 通用工具与常量
    │   ├── ruoyi-framework/      # 框架核心（安全/配置/拦截器）
    │   ├── ruoyi-system/         # 系统管理模块
    │   ├── ruoyi-generator/      # 代码生成器
    │   └── ruoyi-quartz/         # 定时任务模块
    ├── homestay-client/          # 用户端（C 端 + 房东 + 保洁员）
    └── homestay-admin/           # 管理后台
```

---

## 🚀 快速开始

### 环境要求

| 依赖 | 版本要求 |
|------|----------|
| JDK | 17+ |
| Maven | 3.6+ |
| MySQL | 8.0+ |
| Redis | 5.0+ |
| Node.js | 18+（建议 20） |
| pnpm / npm | 任意（项目提供 pnpm-lock 与 package-lock） |

### 1️⃣ 初始化数据库

```sql
# 创建数据库并导入脚本
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS homestay DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -u root -p homestay < 数据库/homestay.sql
```

### 2️⃣ 启动后端

```bash
cd 项目源代码/homestay-server

# 修改数据库连接配置
# 编辑 ruoyi-admin/src/main/resources/application-devmy.yml
#   spring.datasource.druid.master.username / password 改为你的 MySQL 账号密码

# 启动
mvn clean package -DskipTests
java -jar ruoyi-admin/target/*.jar
# 或在 IDEA 中直接运行 ruoyi-admin 下的 HomestayApplication
```

后端默认端口：**8083**

### 3️⃣ 启动用户端（client）

```bash
cd 项目源代码/homestay-client
pnpm install        # 或 npm install
pnpm dev            # 或 npm run dev
```

访问：**http://localhost:3000**（Vite 已配置代理到后端 8083）

### 4️⃣ 启动管理后台（admin）

```bash
cd 项目源代码/homestay-admin
pnpm install        # 或 npm install
pnpm dev            # 或 npm run dev
```

访问：**http://localhost:81**（Vite 已配置代理到后端 8083）

### 默认账号

| 角色 | 账号 | 密码 |
|------|------|------|
| 管理员 | admin | 见数据库 sys_user 表初始数据 |
| 普通用户 | 注册获取 | - |

> 若依框架默认管理员账号 `admin / admin123`，具体以 `sys_user` 表初始数据为准。

---

## ⚙️ 配置文件说明

| 文件 | 作用 |
|------|------|
| `ruoyi-admin/src/main/resources/application.yml` | 主配置（JWT、Redis、OpenAI、七牛云、支付宝） |
| `ruoyi-admin/src/main/resources/application-devmy.yml` | 开发环境数据源配置 |
| `ruoyi-admin/src/main/resources/application-prodmy.yml` | 生产环境数据源配置 |
| `homestay-client/src/config/index.ts` | 高德地图 Key、七牛云上传域名 |
| `homestay-client/build/constant.ts` | 客户端端口（默认 3000） |
| `homestay-admin/vite.config.js` | 后台代理与打包配置 |

> ⚠️ 仓库中的密钥均已替换为占位符（`your-xxx-key`），使用前请在对应配置中填入你自己的：
> DeepSeek API Key、七牛云 AccessKey/SecretKey、支付宝沙箱密钥、高德地图 Key、JWT secret、数据库密码。

---

## 🔨 生产构建

```bash
# 用户端
cd 项目源代码/homestay-client && pnpm build
# 产物输出到 dist/

# 管理后台
cd 项目源代码/homestay-admin && pnpm build:prod
# 产物输出到 dist/（Nginx 需配置 /admin/ 路径）

# 后端
cd 项目源代码/homestay-server && mvn clean package -DskipTests
# 产物：ruoyi-admin/target/*.jar
```

Nginx 参考配置：

```nginx
server {
    listen 80;

    # 用户端
    location / {
        root /var/www/homestay-client/dist;
        try_files $uri $uri/ /index.html;
    }

    # 管理后台
    location /admin/ {
        alias /var/www/homestay-admin/dist/;
        try_files $uri $uri/ /admin/index.html;
    }

    # 后端接口
    location /api/ {
        proxy_pass http://127.0.0.1:8083/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # WebSocket 聊天
    location /ws/ {
        proxy_pass http://127.0.0.1:8083/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

---

## 📜 License

MIT
