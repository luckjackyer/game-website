#!/bin/bash

# ============================================
# 自动化部署脚本 - 适用于Cloudflare Pages项目
# 使用方法：./deploy.sh "提交信息"
# ============================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否在Git仓库中
if [ ! -d ".git" ]; then
    echo -e "${RED}错误：当前目录不是Git仓库！${NC}"
    echo "请先运行：git init"
    exit 1
fi

# 检查是否有提交信息
if [ -z "$1" ]; then
    echo -e "${YELLOW}警告：未提供提交信息，使用默认信息${NC}"
    COMMIT_MSG="更新网站内容 - $(date +'%Y-%m-%d %H:%M:%S')"
else
    COMMIT_MSG="$1"
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🚀 开始自动化部署流程${NC}"
echo -e "${GREEN}========================================${NC}"

# 步骤1：拉取最新代码
echo -e "\n${YELLOW}[1/5]${NC} 拉取最新代码..."
git pull origin main 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}拉取失败！请检查网络连接或解决冲突${NC}"
    exit 1
fi

# 步骤2：检查修改
echo -e "\n${YELLOW}[2/5]${NC} 检查文件修改..."
git status

# 步骤3：添加所有修改
echo -e "\n${YELLOW}[3/5]${NC} 添加修改到暂存区..."
git add .

# 检查是否有修改需要提交
if git diff --cached --quiet; then
    echo -e "${YELLOW}没有检测到修改，跳过提交${NC}"
else
    # 步骤4：提交修改
    echo -e "\n${YELLOW}[4/5]${NC} 提交修改..."
    git commit -m "$COMMIT_MSG"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}提交失败！${NC}"
        exit 1
    fi
fi

# 步骤5：推送到GitHub（自动触发Cloudflare部署）
echo -e "\n${YELLOW}[5/5]${NC} 推送到GitHub..."
git push origin main

if [ $? -ne 0 ]; then
    echo -e "${RED}推送失败！请检查："
    echo -e "  1. GitHub Token是否有效"
    echo -e "  2. 网络连接是否正常"
    echo -e "  3. 远程仓库配置是否正确${NC}"
    exit 1
fi

# 完成
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✅ 部署流程完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n📦 代码已推送到GitHub，Cloudflare Pages将自动部署"
echo -e "⏱️  预计1-3分钟后网站更新生效"
echo -e "\n"
