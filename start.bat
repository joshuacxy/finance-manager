@echo off
echo 启动个人财务管理系统...

echo 1. 启动后端服务器...
start cmd /k "cd backend && npm run dev"

timeout /t 5 /nobreak > nul

echo 2. 启动前端开发服务器...
start cmd /k "cd frontend && npm run dev"

echo 系统启动完成！
echo 前端：http://localhost:3000
echo 后端：http://localhost:5000
pause