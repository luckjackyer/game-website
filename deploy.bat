@echo off
chcp 65001 >nul
REM ============================================
REM 自动化部署脚本(Windows) - 适用于Cloudflare Pages项目
REM 使用方法：deploy.bat "提交信息"
REM ============================================

echo ==========
echo 🚀 开始自动化部署流程
echo ==========

REM 检查是否在Git仓库中
if not exist ".git\" (
    echo ❌ 错误：当前目录不是Git仓库！
    echo 请先运行：git init
    pause
    exit /b 1
)

REM 设置提交信息
if "%~1"=="" (
    echo ⚠️ 警告：未提供提交信息，使用默认信息
    set "COMMIT_MSG=更新网站内容 - %date% %time%"
) else (
    set "COMMIT_MSG=%~1"
)

REM 步骤1：拉取最新代码
echo.
echo [1/5] 拉取最新代码...
git pull origin main
if errorlevel 1 (
    echo ❌ 拉取失败！请检查网络连接或解决冲突
    pause
    exit /b 1
)

REM 步骤2：检查修改
echo.
echo [2/5] 检查文件修改...
git status

REM 步骤3：添加所有修改
echo.
echo [3/5] 添加修改到暂存区...
git add .

REM 检查是否有修改需要提交
git diff --cached --quiet
if %errorlevel%==0 (
    echo ⚠️ 没有检测到修改，跳过提交
) else (
    REM 步骤4：提交修改
    echo.
    echo [4/5] 提交修改...
    git commit -m "%COMMIT_MSG%"
    if errorlevel 1 (
        echo ❌ 提交失败！
        pause
        exit /b 1
    )
)

REM 步骤5：推送到GitHub
echo.
echo [5/5] 推送到GitHub...
git push origin main
if errorlevel 1 (
    echo ❌ 推送失败！请检查：
    echo   1. GitHub Token是否有效
    echo   2. 网络连接是否正常
    echo   3. 远程仓库配置是否正确
    pause
    exit /b 1
)

REM 完成
echo.
echo ==========
echo ✅ 部署流程完成！
echo ==========
echo.
echo 📦 代码已推送到GitHub，Cloudflare Pages将自动部署
echo ⏱️  预计1-3分钟后网站更新生效
echo.
echo 🌐 访问你的网站查看更新
echo.
pause
