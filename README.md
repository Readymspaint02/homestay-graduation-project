<div align="center">

# 🏠 民宿短租管理系统

基于 **Spring Boot 3 + Vue 3** 的前后端分离民宿预订平台，覆盖「浏览房源 → 在线预订 → 支付 → 入住 → 评价」完整业务闭环，支持 **租客 / 房东 / 管理员 / 保洁员** 四类角色协同运营。

</div>

## 📺 项目演示视频

[B站讲解视频：民宿短租系统演示](https://www.bilibili.com/video/BV1zGp96VEfR/)

---

## ✨ 项目介绍

本系统是一个面向民宿短租场景的综合性预订平台，参照 **《旅游民宿基本要求与等级划分》（LB/T 065-2019）** 与 **《信息安全技术个人信息安全规范》（GB/T 35273-2020）** 等行业标准进行设计与实现，包含 **租客端（C 端）**、**房东工作台**、**保洁员端** 和 **管理后台** 四类角色入口。

平台以房源数据为业务流转中心，实现了从房源发布审核、在线预订支付、日历房态管理、清洁任务调度，到即时通讯、AI 选房助手、监管上报的民宿运营管理闭环。

### 核心功能

| 模块 | 功能说明 |
|------|----------|
| 🏡 房源管理 | 房源发布、多图展示、设施标签、分类、上下架、管理员审核 |
| 📅 日历房态 | 房间价格日历、可订/已订/清洁中/不可用状态、乐观锁并发控制 |
| 📝 订单系统 | 在线预订、支付宝沙箱支付、状态机流转、超时自动取消 |
| ⭐ 评价体系 | 用户评价、评分、评论回复、评价审核 |
| 🧹 清洁管理 | 退房自动生成清洁任务、任务完成后自动释放房态，形成业务闭环 |
| 💬 即时通讯 | WebSocket 实时聊天（租客↔房东）、断线自动降级 HTTP 轮询 |
| 🤖 AI 助手 | 基于 DeepSeek 大模型的智能客服、AI 选房、房源对比、SSE 流式输出 |
| 🗺️ 地图服务 | 高德地图 API 房源定位、周边兴趣点搜索、路线规划 |
| 📊 数据看板 | 平台运营数据可视化（订单趋势、用户增长、房源分布），Redis 缓存 |
| 🔔 监管上报 | 经营数据按行业标准格式上报文旅/公安部门，支持手动与定时自动上报 |

### 订单状态机

```
待支付(0) → 已支付(1) → 已确认(2) → 已入住(3) → 已完成(4)
    └──────→ 已取消(5)
```

### 系统核心参数设计

| 参数 | 参数值 | 设计依据 |
|------|--------|----------|
| Redis 缓存 TTL | 1800s | 房源信息更新频率与用户体验平衡 |
| 定时任务扫描间隔 | 5 分钟 | 参考途家、木鸟等主流平台订单超时检查周期 |
| 订单支付超时阈值 | 30 分钟 | 《中国民宿短租行业白皮书》：用户平均下单决策 23 分钟 |
| 订单确认超时 | 24 小时 | 超过 24 小时未确认视为房东拒绝 |
| 异常订单金额阈值 | 20000 元 | 基于平台历史交易 P99 分位数 |
| 异常退款率阈值 | 60% | 行业监管标准，触发异常交易预警 |

### 系统异常处理框架

| 异常类型 | 场景 | 处理策略 |
|----------|------|----------|
| 业务异常 | 订单超时未支付、房态库存不足、日期无效 | 用户提示 + 自动纠错（Quartz 定时扫描自动取消超时订单） |
| 系统异常 | 七牛云不可用、AI 接口超时、数据库中断 | 服务降级 + 熔断（七牛降级本地磁盘、AI 熔断切换本地 FAQ） |
| 数据异常 | 参数格式错误、必填字段缺失 | 全局异常拦截器统一校验，返回结构化错误响应 |

---

## 🛠️ 技术栈

**后端**

- Java 17 · Spring Boot 3.5 · Spring Security · MyBatis-Plus
- MySQL 8 · Redis（分布式锁 + 缓存）· Druid 连接池
- JWT 认证 · Quartz 定时任务 · WebSocket · SSE
- 支付宝沙箱支付 · 七牛云对象存储 · DeepSeek AI 大模型
- 基于若依（RuoYi 3.9.1）多模块架构

**前端**

| 端 | 技术栈 | 端口 |
|----|--------|------|
| `homestay-client`（租客端 + 房东端 + 保洁员端） | Vue 3 + TypeScript + Ant Design Vue + Pinia + ECharts + 高德地图 | 3000 |
| `homestay-admin`（管理后台） | Vue 3 + Element Plus + Pinia + ECharts + Vite | 81 |

**性能测试（JMeter 压测）**

| 测试场景 | 并发用户数 | 平均响应时间 | 吞吐量 | 错误率 |
|----------|-----------|-------------|--------|--------|
| 房源列表查询 | 100 | 89ms | 1120/s | 0% |
| 房源列表查询 | 1000 | 342ms | 2920/s | 0.1% |
| 订单创建 | 100 | 125ms | 800/s | 0% |
| 订单创建 | 1000 | 534ms | 1870/s | 0.2% |

> 借助 Redis 缓存与分布式锁，房源列表查询平均响应时间控制在 100ms 以内，订单创建在 300ms 以内。

---

## 📁 项目结构

```
homestay-graduation-project/
├── 数据库/
│   └── homestay.sql              # 完整建库脚本（业务表 + 若依框架表）
└── 项目源代码/
    ├── homestay-server/          # 后端服务（Spring Boot 多模块 Maven 项目）
    │   ├── ruoyi-admin/          # 启动模块 / 配置文件 / 入口
    │   ├── ruoyi-biz/            # 民宿业务模块（核心业务代码）
    │   ├── ruoyi-common/         # 通用工具与常量
    │   ├── ruoyi-framework/      # 框架核心（安全/配置/拦截器）
    │   ├── ruoyi-system/         # 系统管理模块
    │   ├── ruoyi-generator/      # 代码生成器
    │   └── ruoyi-quartz/         # 定时任务模块
    ├── homestay-client/          # 用户端（租客 + 房东 + 保洁员）
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

# 修改数据库连接配置（ruoyi-admin/src/main/resources/application-devmy.yml）
#   spring.datasource.druid.master.username / password 改为你的 MySQL 账号密码

mvn clean package -DskipTests
java -jar ruoyi-admin/target/*.jar
# 或在 IDEA 中直接运行 ruoyi-admin 下的 HomestayApplication
```

后端默认端口：**8083**

### 3️⃣ 启动用户端（client）

```bash
cd 项目源代码/homestay-client
pnpm install        # 或 npm install
pnpm dev
```

访问：**http://localhost:3000**（Vite 已配置代理到后端 8083）

### 4️⃣ 启动管理后台（admin）

```bash
cd 项目源代码/homestay-admin
pnpm install        # 或 npm install
pnpm dev
```

访问：**http://localhost:81**（Vite 已配置代理到后端 8083）

### 默认账号

| 角色 | 说明 |
|------|------|
| 管理员 | admin（若依默认密码 admin123，以 sys_user 表初始数据为准） |
| 租客 / 房东 | 前端注册获取 |

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

# 管理后台
cd 项目源代码/homestay-admin && pnpm build:prod

# 后端
cd 项目源代码/homestay-server && mvn clean package -DskipTests
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

---

## 📮 联系作者

- 📧 邮箱：**3500498546@qq.com**
- 📧 Gmail：**ryo210856837@gmail.com**
- 📺 B站：[民宿短租系统讲解视频](https://www.bilibili.com/video/BV1zGp96VEfR/)
