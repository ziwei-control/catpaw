# 📤 CatPaw 推送到 GitHub 和 Gitee 指南

**更新时间**: 2026-04-12

---

## ✅ 已完成

- [x] Git 仓库初始化
- [x] 首次提交 (36 个文件)
- [x] 配置 Git 用户信息
- [x] 创建推送脚本

---

## 📋 推送步骤

### 步骤 1: 在 GitHub 创建仓库

1. 访问：https://github.com/new
2. 填写信息：
   - **Repository name**: `catpaw`
   - **Description**: "Markdown 驱动的本地化自主智能体系统"
   - **Public/Private**: 选择 Public (公开) 或 Private (私有)
   - ❌ 不要勾选 "Add README"
   - ❌ 不要勾选 "Add .gitignore"
   - ❌ 不要勾选 "Choose a license"
3. 点击 **Create repository**

### 步骤 2: 在 Gitee 创建仓库

1. 访问：https://gitee.com/new
2. 填写信息：
   - **仓库路径**: `catpaw`
   - **仓库名称**: `CatPaw`
   - **仓库介绍**: "Markdown 驱动的本地化自主智能体系统"
   - **开源/私有**: 选择公开或私有
   - ❌ 不要勾选 "初始化仓库"
   - ❌ 不要勾选 "添加开源许可证"
3. 点击 **创建**

### 步骤 3: 配置 SSH Key (如果还没有)

#### 检查现有 Key

```bash
ls -la ~/.ssh/id_*.pub
```

如果有 `id_rsa.pub` 或 `id_ed25519.pub`，跳过生成步骤。

#### 生成新 Key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# 一路回车
```

#### 添加 Key 到 GitHub

1. 复制公钥：
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. 访问：https://github.com/settings/keys

3. 点击 **New SSH key**

4. 粘贴公钥，保存

#### 添加 Key 到 Gitee

1. 复制公钥：
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. 访问：https://gitee.com/profile/sshkeys

3. 点击 **添加 SSH 公钥**

4. 粘贴公钥，保存

### 步骤 4: 运行推送脚本

```bash
cd /home/admin/projects/catpaw

# 编辑脚本，修改用户名 (如果需要)
vim push_to_repo.sh
# 修改 GITHUB_USER 和 GITEE_USER

# 运行脚本
./push_to_repo.sh
```

---

## 🔧 手动推送 (备选方案)

如果不想用脚本，可以手动执行：

### 添加远程仓库

```bash
cd /home/admin/projects/catpaw

# GitHub
git remote add origin git@github.com:YOUR_USERNAME/catpaw.git

# Gitee
git remote add gitee git@gitee.com:YOUR_USERNAME/catpaw.git
```

### 推送到 GitHub

```bash
git push -u origin main
```

### 推送到 Gitee

```bash
git push -u gitee main
```

### 同时推送到两个远程

```bash
git push origin main && git push gitee main
```

---

## 🔍 验证推送

### 检查远程仓库

```bash
git remote -v
```

应该看到：
```
origin  git@github.com:YOUR_USERNAME/catpaw.git (fetch)
origin  git@github.com:YOUR_USERNAME/catpaw.git (push)
gitee   git@gitee.com:YOUR_USERNAME/catpaw.git (fetch)
gitee   git@gitee.com:YOUR_USERNAME/catpaw.git (push)
```

### 查看提交历史

```bash
git log --oneline
```

### 检查分支

```bash
git branch -a
```

---

## ⚠️ 常见问题

### 问题 1: "Permission denied (publickey)"

**原因**: SSH Key 未配置或配置错误

**解决**:
```bash
# 测试 GitHub 连接
ssh -T git@github.com

# 测试 Gitee 连接
ssh -T git@gitee.com
```

如果失败，重新配置 SSH Key。

### 问题 2: "remote origin already exists"

**原因**: 远程仓库已存在

**解决**:
```bash
# 删除现有远程
git remote remove origin

# 重新添加
git remote add origin git@github.com:YOUR_USERNAME/catpaw.git
```

### 问题 3: "Updates were rejected"

**原因**: 远程仓库有提交历史

**解决**:
```bash
# 强制推送 (谨慎使用)
git push -u origin main --force
```

### 问题 4: "fatal: refused to merge unrelated histories"

**原因**: 本地和远程仓库历史不同

**解决**:
```bash
# 允许合并不同历史
git pull origin main --allow-unrelated-histories
git push origin main
```

---

## 🔄 后续更新

### 日常推送

```bash
cd /home/admin/projects/catpaw

# 提交更改
git add .
git commit -m "更新说明"

# 推送到两个平台
git push origin main
git push gitee main
```

### 或使用脚本

```bash
./push_to_repo.sh
```

---

## 📊 仓库信息

### GitHub

- **URL**: https://github.com/YOUR_USERNAME/catpaw
- **SSH**: git@github.com:YOUR_USERNAME/catpaw.git
- **HTTPS**: https://github.com/YOUR_USERNAME/catpaw.git

### Gitee

- **URL**: https://gitee.com/YOUR_USERNAME/catpaw
- **SSH**: git@gitee.com:YOUR_USERNAME/catpaw.git
- **HTTPS**: https://gitee.com/YOUR_USERNAME/catpaw.git

---

## 💡 最佳实践

### 1. 提交信息规范

```bash
# 功能添加
git commit -m "feat: 添加 Web 界面配置功能"

# Bug 修复
git commit -m "fix: 修复端口占用问题"

# 文档更新
git commit -m "docs: 更新 README"

# 配置更改
git commit -m "chore: 更新 .gitignore"
```

### 2. 分支管理

```bash
# 创建开发分支
git checkout -b dev

# 开发完成后合并到 main
git checkout main
git merge dev
```

### 3. 标签版本

```bash
# 创建版本标签
git tag -a v0.3.0 -m "CatPaw v0.3.0"
git push origin v0.3.0
```

---

## 📞 需要帮助？

如果遇到其他问题，查看：

- Git 官方文档：https://git-scm.com/doc
- GitHub 帮助：https://docs.github.com/
- Gitee 帮助：https://gitee.com/help

---

**最后更新**: 2026-04-12  
**版本**: v0.3.0
