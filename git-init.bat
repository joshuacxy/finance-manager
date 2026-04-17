@echo off
echo ========================================
echo Git仓库初始化脚本 - 个人财务管理系统
echo ========================================
echo.

echo 步骤1: 检查当前目录
cd /d "%~dp0"
echo 当前目录: %CD%
echo.

echo 步骤2: 初始化Git仓库
if exist ".git" (
    echo .git目录已存在
) else (
    git init
    echo Git仓库初始化完成
)
echo.

echo 步骤3: 检查远程仓库配置
git remote -v
echo.

echo 步骤4: 添加远程仓库（如果需要）
set /p add_remote="是否添加远程仓库？(y/n): "
if /i "%add_remote%"=="y" (
    git remote add origin https://github.com/joshuacxy/finance-manager.git
    echo 远程仓库已添加
)
echo.

echo 步骤5: 检查文件状态
git status
echo.

echo 步骤6: 添加所有文件
set /p add_files="是否添加所有文件到暂存区？(y/n): "
if /i "%add_files%"=="y" (
    git add .
    echo 文件已添加到暂存区
)
echo.

echo 步骤7: 创建提交
set /p make_commit="是否创建提交？(y/n): "
if /i "%make_commit%"=="y" (
    set /p commit_msg="请输入提交消息: "
    if "%commit_msg%"=="" set commit_msg="初始提交：个人财务管理系统"
    git commit -m "%commit_msg%"
    echo 提交已创建
)
echo.

echo 步骤8: 推送到GitHub
set /p push_repo="是否推送到GitHub？(y/n): "
if /i "%push_repo%"=="y" (
    git branch -M main
    git push -u origin main
    echo 推送完成！
)
echo.

echo ========================================
echo 脚本执行完成
echo ========================================
pause