# 🚀 快速部署指南 - 适用于后续所有网站

## 📋 首次部署流程（一次性设置）

### 1️⃣ 创建GitHub仓库并推送
```bash
# 在GitHub创建新仓库（手动或通过API）
# 然后执行：
cd your-project-folder
git init
git add .
git commit -m "初始提交"
git branch -M main
git remote add origin https://github.com/your-username/your-repo.git
git push -u origin main
```

### 2️⃣ 连接Cloudflare Pages
1. 访问：https://dash.cloudflare.com/
2. 进入 **Pages** → **Create a project**
3. 选择 **Connect to Git**
4. 授权并选择仓库
5. 配置：
   - Build command: (留空)
   - Build output directory: `/`
6. 点击 **Save and Deploy**

✅ **完成！之后每次 `git push` 都会自动部署**

---

## 🔄 后续更新流程（每次5分钟）

### 方法1：使用自动化脚本（推荐）

**Linux/Mac**：
```bash
# 首次使用需赋予执行权限
chmod +x deploy.sh

# 之后每次更新只需运行：
./deploy.sh "描述你的修改内容"
```

**Windows**：
```batch
REM 直接运行
deploy.bat "描述你的修改内容"
```

### 方法2：手动Git命令
```bash
# 1. 拉取最新代码（如果多人协作）
git pull origin main

# 2. 修改文件...
# 使用编辑器修改代码

# 3. 提交并推送
git add .
git commit -m "描述你的修改内容"
git push origin main

# 4. 等待1-3分钟，访问网站查看更新
```

---

## 📊 项目模板生成器

### 快速创建新网站项目

**使用此模板创建新项目**：
```bash
# 复制本项目的结构
cp -r game-website new-website
cd new-website

# 移除原有的Git历史
rm -rf .git

# 初始化新仓库
git init
git add .
git commit -m "初始提交"

# 修改内容...
# 然后部署（参考上述流程）
```

---

## 🎯 常见修改场景

### 场景1：修改现有游戏/页面
```bash
# 1. 修改文件（例如：games/tetris.html）
# 使用编辑器打开并修改代码

# 2. 测试（本地打开HTML文件）

# 3. 部署
./deploy.sh "优化俄罗斯方块游戏难度"
```

### 场景2：添加新游戏/页面
```bash
# 1. 创建新游戏文件
touch games/newgame.html
touch games/newgame.js
touch games/newgame.css

# 2. 编写游戏代码...

# 3. 在首页添加链接（index.html）
# 在 <main class="games-grid"> 中添加游戏卡片

# 4. 部署
./deploy.sh "添加新游戏：XXX"
```

### 场景3：修改样式/布局
```bash
# 1. 修改CSS文件
# 编辑 css/style.css

# 2. 测试样式效果

# 3. 部署
./deploy.sh "优化移动端响应式布局"
```

### 场景4：修复Bug
```bash
# 1. 定位并修复bug

# 2. 测试修复效果

# 3. 部署
./deploy.sh "修复XXX功能的XXX问题"
```

---

## 🔧 故障排查

### 问题1：推送失败（认证错误）
```bash
# 检查远程仓库配置
git remote -v

# 重新设置远程仓库（使用Token）
git remote set-url origin https://<EMAIL_REMOVED>/username/repo.git

# 再次推送
git push origin main
```

### 问题2：部署后网站未更新
```bash
# 1. 清除浏览器缓存（Ctrl+Shift+Delete）
# 2. 或打开无痕窗口测试
# 3. 或在Cloudflare Dashboard清除缓存
```

### 问题3：Cloudflare部署失败
```bash
# 1. 检查构建日志
#    Cloudflare Dashboard → Pages → 项目 → Deployments

# 2. 常见问题：
#    - 构建命令错误 → 留空（纯静态网站）
#    - 输出目录错误 → 设置为 `/` 或 `dist`

# 3. 重新部署
#    Cloudflare Dashboard → 点击 "Retry deployment"
```

---

## 📝 提交信息规范

### 好的提交信息示例
```
✅ "修复俄罗斯方块碰撞检测bug"
✅ "添加新游戏：扫雷"
✅ "优化移动端触摸控制体验"
✅ "更新首页布局，添加搜索功能"
✅ "修复记分板localStorage读取错误"
```

### 不好的提交信息
```
❌ "更新"
❌ "修复"
❌ "asdf"
❌ "123"
```

**建议**：提交信息要**简洁明了**，一眼看出这次提交做了什么

---

## 🎨 新网站快速启动清单

当你要创建下一个网站时，按此清单操作：

- [ ] 创建项目文件夹
- [ ] 创建标准目录结构（index.html, css/, js/, assets/）
- [ ] 编写首页和基础样式
- [ ] 初始化Git仓库（`git init`）
- [ ] 创建GitHub仓库
- [ ] 推送代码到GitHub
- [ ] 在Cloudflare Pages连接仓库
- [ ] 配置部署设置（Build command留空，输出目录 `/`）
- [ ] 等待首次部署完成
- [ ] 访问网站测试
- [ ] 复制 `deploy.sh` 或 `deploy.bat` 到新项目
- [ ] 测试自动化部署脚本

**预计时间**：首次部署30-45分钟，后续每次更新5分钟

---

## 💡 专业建议

### 1. 使用分支进行实验
```bash
# 创建新分支测试新功能
git checkout -b feature/new-feature

# 在新分支上修改代码...
git add .
git commit -m "实验性新功能"

# 测试通过后合并到主分支
git checkout main
git merge feature/new-feature
git push origin main
```

### 2. 使用Git标签标记版本
```bash
# 标记稳定版本
git tag -a v1.0 -m "第一个稳定版本"
git push origin v1.0

# 查看所有版本
git tag
```

### 3. 设置自定义域名（可选）
1. 在域名注册商添加Cloudflare Nameservers
2. Cloudflare Dashboard → Pages → 项目 → Custom domains
3. 添加域名并设置DNS记录

---

## 📞 需要帮助？

**常见问题文档**：
- Cloudflare Pages：https://developers.cloudflare.com/pages/
- GitHub Docs：https://docs.github.com/
- Git Cheat Sheet：https://education.github.com/git-cheat-sheet-education.pdf

**快速参考**：
- 部署命令：`./deploy.sh "提交信息"`
- 查看网站：`https://your-project.pages.dev`
- 查看部署：Cloudflare Dashboard → Pages → 项目

---

**最后更新**：2026-05-10
**适用项目**：所有纯静态网站（HTML/CSS/JS）
**作者**：AI助手
