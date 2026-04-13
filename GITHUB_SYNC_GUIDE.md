# 📤 CatPaw GitHub/Gitee 同步指南

**更新时间**: 2026-04-12  
**版本**: v0.3.0

---

## ✅ Git 仓库已初始化

Git 仓库已在 `/home/admin/projects/catpaw/.git` 初始化完成。

---

## 🚀 快速同步 (3 步)

### 步骤 1: 创建远程仓库

**⚠️ 重要**: 避免与官方项目冲突！

**建议仓库名称**:
- `catpaw-python` (推荐)
- `catpaw-md` (Markdown 驱动)
- `md-talon`
- `catpaw-cn`

**不要使用**: `catpaw` (与官方项目同名)

#### GitHub 创建仓库

1. 访问：https://github.com/new
2. 仓库名：`catpaw-python`
3. 描述：`Markdown 驱动的本地化自主智能体系统 (Python 版)`
4. 公开/私有：选择公开
5. **不要** 初始化 README/.gitignore (我们已有)
6. 点击 **Create repository**

#### Gitee 创建仓库

1. 访问：https://gitee.com/new
2. 仓库名：`catpaw-python`
3. 描述：`Markdown 驱动的本地化自主智能体系统 (Python 版)`
4. 公开/私有：选择公开
5. **不要** 初始化 README/.gitignore
6. 点击 **创建**

---

### 步骤 2: 配置远程仓库

```bash
cd /home/admin/projects/catpaw

# 配置 Git 用户信息
git config user.email "your-email@example.com"
git config user.name "Your Name"

# 提交代码
git add .
git commit -m "Initial commit: CatPaw v0.3.0 - Markdown 驱动的智能体系统"

# 添加 GitHub 远程 (替换为你的仓库地址)
git remote add github https://github.com/YOUR_USERNAME/catpaw-python.git

# 添加 Gitee 远程 (替换为你的仓库地址)
git remote add gitee https://gitee.com/YOUR_USERNAME/catpaw-python.git

# 推送到 GitHub
git push -u github main

# 推送到 Gitee
git push -u gitee main
```

---

### 步骤 3: 验证同步

**GitHub**:
```bash
# 查看远程仓库
git remote -v

# 应该显示:
# github  https://github.com/YOUR_USERNAME/catpaw-python.git (fetch)
# github  https://github.com/YOUR_USERNAME/catpaw-python.git (push)
# gitee   https://gitee.com/YOUR_USERNAME/catpaw-python.git (fetch)
# gitee   https://gitee.com/YOUR_USERNAME/catpaw-python.git (push)
```

**访问仓库页面确认代码已上传**。

---

## 🔄 后续同步

### 推送更新到两个平台

```bash
cd /home/admin/projects/catpaw

# 提交更改
git add .
git commit -m "Update: 描述你的更改"

# 推送到两个平台
git push github main
git push gitee main
```

### 使用同步脚本

```bash
./sync_to_repos.sh
```

脚本会自动：
1. 配置 Git 用户信息
2. 检查未提交的更改
3. 提示输入仓库地址
4. 配置远程仓库
5. 推送到 GitHub 和 Gitee

---

## ⚠️ 常见问题

### 问题 1: 推送失败 - 权限错误

**原因**: SSH Key 未配置

**解决**:
```bash
# 生成 SSH Key
ssh-keygen -t ed25519 -C "your-email@example.com"

# 查看公钥
cat ~/.ssh/id_ed25519.pub

# 复制公钥到:
# GitHub: https://github.com/settings/keys
# Gitee:  https://gitee.com/profile/sshkeys
```

### 问题 2: 推送失败 - 分支不存在

**解决**:
```bash
# 强制推送
git push -u github main --force
git push -u gitee main --force
```

### 问题 3: 与官方项目冲突

**解决**: 重命名仓库为 `catpaw-python` 或其他名称。

---

## 📊 项目信息

**项目名称**: CatPaw (Python 版)  
**版本**: v0.3.0  
**许可证**: MIT (建议)  
**语言**: Python 3.8+  
**核心特性**:
- Markdown 驱动配置
- 云模型支持 (Kimi/Qwen/DeepSeek)
- Web 界面 + CLI
- 技能系统框架

**区别于官方项目**:
| 特性 | 本项目 | 官方项目 |
|------|--------|---------|
| 语言 | Python | Go |
| 配置 | Markdown | YAML/JSON |
| 定位 | 本地化智能体 | OpenClaw 替代 |
| 创建时间 | 2026-04-09 | 2026-02-21 |

---

## 📝 推荐仓库描述

```
🤖 CatPaw (Python 版)

Markdown 驱动的本地化自主智能体系统

✨ 特性:
- 📝 Markdown 即灵魂 - 所有配置可读可编辑
- ☁️ 云模型支持 - Kimi2.5, Qwen3.5, DeepSeek 等
- 🌐 Web 界面 - 美观的网页聊天界面
- 💬 CLI 交互 - 命令行对话
- 🔧 技能系统 - 可扩展的技能框架
- 🔒 隐私优先 - 本地部署，数据可控

🚀 快速开始:
pip3 install flask flask-cors
./start.sh

📖 文档: 详见 QUICKSTART.md

⚠️ 注意: 本项目为 Python 实现，区别于官方的 Go 版本 (github.com/catpaw/catpaw)
```

---

**完成同步后，记得更新 README.md 中的仓库链接!**
