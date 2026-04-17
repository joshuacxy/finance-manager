# 部署指南

本文档介绍如何将个人财务管理网站部署到云端。

## 部署选项

### 选项1：Vercel（前端）+ Railway（后端）（推荐）
最简单的全栈部署方案，提供免费额度。

### 选项2：Vercel（全栈）
使用Vercel Serverless Functions部署后端API。

### 选项3：Render（全栈）
一体化部署方案，支持Node.js后端和静态前端。

## 选项1：Vercel + Railway 部署

### 步骤1：部署后端到 Railway

1. **创建 Railway 账户**
   - 访问 [railway.app](https://railway.app)
   - 使用 GitHub 登录

2. **创建新项目**
   - 点击 "New Project"
   - 选择 "Deploy from GitHub repo"
   - 授权 Railway 访问你的 GitHub 仓库

3. **配置环境变量**
   - 在 Railway 项目设置中添加以下环境变量：
     ```
     DATABASE_URL="postgresql://..."
     JWT_SECRET="your-strong-jwt-secret"
     NODE_ENV="production"
     FRONTEND_URL="https://your-frontend-domain.vercel.app"
     PORT="5000"
     ```
   - Railway 会自动提供 PostgreSQL 数据库，DATABASE_URL 会自动设置

4. **部署设置**
   - Railway 会自动检测到 `backend/package.json`
   - 构建命令：`npm install && npm run build`
   - 启动命令：`npm start`
   - 根目录设置为 `/backend`

5. **获取后端URL**
   - 部署完成后，Railway 会提供一个URL，如：`https://your-backend.up.railway.app`
   - 记下这个URL，前端会用到

### 步骤2：部署前端到 Vercel

1. **创建 Vercel 账户**
   - 访问 [vercel.com](https://vercel.com)
   - 使用 GitHub 登录

2. **导入项目**
   - 点击 "Add New" → "Project"
   - 选择你的 GitHub 仓库
   - 在 "Import Git Repository" 中授权访问

3. **配置项目**
   - Framework Preset: Vite
   - Root Directory: `frontend`
   - Build Command: `npm run build`
   - Output Directory: `dist`
   - Install Command: `npm install`

4. **环境变量**
   - 添加环境变量：
     ```
     VITE_API_URL=https://your-backend.up.railway.app/api
     ```

5. **部署**
   - 点击 "Deploy"
   - Vercel 会自动构建和部署
   - 部署完成后会获得一个URL，如：`https://your-project.vercel.app`

### 步骤3：更新 CORS 配置

1. 回到 Railway 项目
2. 更新 `FRONTEND_URL` 环境变量为你的 Vercel 域名
3. 重启后端服务

## 选项2：Vercel 全栈部署

### 步骤1：修改项目结构

1. **创建 API 目录**
   ```
   /api
     /auth
       [...].ts
     /transactions
       [...].ts
     /index.ts
   ```

2. **使用 Vercel Serverless Functions**
   - 将后端API转换为Serverless Functions
   - 参考 Vercel 文档：https://vercel.com/docs/functions

### 步骤2：部署到 Vercel

1. 导入项目到 Vercel
2. Vercel 会自动检测为全栈项目
3. 配置环境变量

## 选项3：Render 部署

### 步骤1：部署后端

1. **创建 Render 账户**
   - 访问 [render.com](https://render.com)

2. **创建 Web Service**
   - 选择 "New" → "Web Service"
   - 连接 GitHub 仓库
   - 配置：
     - Name: `finance-manager-backend`
     - Environment: Node
     - Build Command: `cd backend && npm install && npm run build`
     - Start Command: `cd backend && npm start`
     - Plan: Free

3. **环境变量**
   - 添加与 Railway 相同的环境变量
   - 使用 Render 的 PostgreSQL 数据库

### 步骤2：部署前端

1. **创建 Static Site**
   - 选择 "New" → "Static Site"
   - 连接 GitHub 仓库
   - 配置：
     - Build Command: `cd frontend && npm install && npm run build`
     - Publish Directory: `frontend/dist`
   - 添加环境变量：`VITE_API_URL`

## 数据库设置

### 生产数据库推荐
1. **Railway PostgreSQL**（最简单）
2. **Supabase**（免费额度大）
3. **Neon.tech**（PostgreSQL Serverless）
4. **PlanetScale**（MySQL兼容）

### 迁移到生产数据库
1. 更新 `backend/prisma/schema.prisma` 的 `datasource db`：
   ```prisma
   datasource db {
     provider = "postgresql"
     url      = env("DATABASE_URL")
   }
   ```

2. 运行生产环境迁移：
   ```bash
   npx prisma migrate deploy
   ```

## 环境变量配置

### 生产环境变量
```bash
# 后端
DATABASE_URL="postgresql://..."
JWT_SECRET="至少32位随机字符串"
NODE_ENV="production"
FRONTEND_URL="https://你的前端域名"
PORT="5000"

# 前端
VITE_API_URL="https://你的后端域名/api"
```

### 生成 JWT_SECRET
```bash
# Linux/Mac
openssl rand -base64 32

# Windows PowerShell
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))
```

## 域名配置（可选）

### 自定义域名
1. **Vercel**：在项目设置中添加域名
2. **Railway**：支持自定义域名（需要付费计划）
3. **Render**：免费计划支持自定义域名

### SSL 证书
- 所有推荐平台都自动提供 SSL 证书
- 无需额外配置

## 监控和维护

### 日志查看
1. **Vercel**：项目页面 → "Logs"
2. **Railway**：项目 → "Logs"
3. **Render**：服务 → "Logs"

### 错误监控
- 考虑集成 Sentry 或 LogRocket

### 备份策略
1. 定期导出数据库备份
2. 使用平台提供的自动备份功能

## 故障排除

### 常见问题
1. **CORS 错误**：检查 `FRONTEND_URL` 环境变量
2. **数据库连接失败**：检查 `DATABASE_URL` 格式
3. **构建失败**：检查 Node.js 版本兼容性
4. **API 404**：检查路由配置和代理设置

### 本地测试生产环境
```bash
# 设置生产环境变量
export NODE_ENV=production
export DATABASE_URL="..."
export JWT_SECRET="..."

# 构建和运行
cd backend
npm run build
npm start
```

## 成本估算

### 免费方案
- **Vercel**：每月100GB带宽，Serverless Functions 100小时
- **Railway**：每月5美元额度，足够小型应用
- **Render**：Web Service 750小时/月，PostgreSQL 90小时/月

### 小型团队方案（~10用户）
- 预计每月 $10-20

## 支持

如有部署问题，请参考：
- [Vercel 文档](https://vercel.com/docs)
- [Railway 文档](https://docs.railway.app)
- [Render 文档](https://render.com/docs)
- [Prisma 文档](https://www.prisma.io/docs)