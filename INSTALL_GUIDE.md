# 🚀 CatPaw 一键安装指南

**让 CatPaw 像 CoPaw 和 OpenCat 一样，一键安装！**

---

## ⚡ 一键安装（推荐）

### 方式 1: 从 GitHub 安装

```bash
curl -fsSL https://raw.githubusercontent.com/your-repo/catpaw/main/install.sh | bash
```

### 方式 2: 从 Gitee 安装（国内加速）

```bash
curl -fsSL https://gitee.com/your-repo/catpaw/raw/main/install.sh | bash
```

### 方式 3: 本地安装（已有代码）

```bash
cd /path/to/catpaw
chmod +x install.sh
./install.sh
```

---

## 📋 安装过程

一键安装脚本会自动完成以下操作：

| 步骤 | 操作 | 说明 |
|------|------|------|
| 1️⃣ | 检查系统要求 | Python3, pip3, git, curl |
| 2️⃣ | 选择安装目录 | ~/catpaw 或 /opt/catpaw |
| 3️⃣ | 克隆代码 | GitHub 或 Gitee |
| 4️⃣ | 安装依赖 | Flask, requests 等 |
| 5️⃣ | 配置 LLM | Kimi/Qwen/DeepSeek |
| 6️⃣ | 创建命令 | `catpaw` 命令 |

---

## 🎯 安装后使用

### 快速启动

```bash
# 命令行模式
catpaw cli

# Web 模式
catpaw web

# 配置 API
catpaw config
```

### 进入目录使用

```bash
cd ~/catpaw

# 快速配置并启动
./setup_and_start.sh

# 仅启动 CLI
python3 catpaw.py cli

# 启动 Web 服务
./start_web.sh
```

---

## 🔧 手动安装（可选）

如果不想用一键安装脚本，可以手动安装：

### 步骤 1: 克隆代码

```bash
git clone https://github.com/your-repo/catpaw.git ~/catpaw
cd ~/catpaw
```

### 步骤 2: 安装依赖

```bash
pip3 install flask flask-cors requests --user
```

### 步骤 3: 配置 LLM

```bash
python3 configure_llm.py
```

### 步骤 4: 创建命令（可选）

```bash
mkdir -p ~/bin
cat > ~/bin/catpaw << 'EOF'
#!/bin/bash
cd "$HOME/catpaw"
python3 catpaw.py "$@"
EOF
chmod +x ~/bin/catpaw
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 📊 系统要求

| 要求 | 最低 | 推荐 |
|------|------|------|
| **操作系统** | Linux/macOS | Ubuntu 20.04+ |
| **Python** | 3.6+ | 3.8+ |
| **内存** | 512MB | 1GB+ |
| **磁盘** | 100MB | 500MB+ |
| **网络** | 需要 | 稳定连接 |

---

## 🌐 云模型配置

CatPaw 支持多种云模型：

### Kimi2.5（推荐长文档）

```json
{
  "provider": "openai",
  "api_key": "sk-kimi-your-key",
  "base_url": "https://api.moonshot.cn/v1",
  "model": "kimi-latest"
}
```

**获取 Key**: https://platform.moonshot.cn/

### Qwen3.5（推荐代码）

```json
{
  "provider": "openai",
  "api_key": "sk-qwen-your-key",
  "base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1",
  "model": "qwen-max"
}
```

**获取 Key**: https://dashscope.console.aliyun.com/

### DeepSeek（推荐性价比）

```json
{
  "provider": "openai",
  "api_key": "sk-ds-your-key",
  "base_url": "https://api.deepseek.com/v1",
  "model": "deepseek-chat"
}
```

**获取 Key**: https://platform.deepseek.com/

---

## 🛠️ 故障排除

### 问题 1: curl 命令失败

```bash
# 安装 curl
sudo apt-get install curl  # Ubuntu/Debian
sudo yum install curl      # CentOS/RHEL
```

### 问题 2: Python3 版本过低

```bash
# Ubuntu/Debian
sudo apt-get install python3.8

# CentOS/RHEL
sudo yum install python38
```

### 问题 3: pip3 权限问题

```bash
# 使用 --user 参数
pip3 install --user flask flask-cors requests

# 或使用 sudo
sudo pip3 install flask flask-cors requests
```

### 问题 4: Git 克隆失败

```bash
# 检查网络
ping github.com

# 使用 Gitee 镜像
git clone https://gitee.com/your-repo/catpaw.git
```

### 问题 5: 命令找不到

```bash
# 刷新 PATH
source ~/.bashrc

# 或直接用完整路径
~/catpaw/setup_and_start.sh
```

---

## 📚 对比：CoPaw / OpenCat / CatPaw

| 项目 | 一键安装 | 配置方式 | 启动命令 |
|------|----------|----------|----------|
| **CoPaw** | ✅ `curl ... \| bash` | 自动配置 | `copaw` |
| **OpenCat** | ✅ `./setup_and_start.sh` | 交互式 | `./start.sh` |
| **CatPaw** | ✅ `curl ... \| bash` | 交互式 | `catpaw` |

现在三个项目都支持一键安装了！🎉

---

## 💡 高级用法

### 静默安装（无交互）

```bash
# 设置环境变量自动确认
export INSTALL_DIR=~/catpaw
export LLM_PROVIDER=kimi
export API_KEY=sk-your-key

curl -fsSL https://raw.githubusercontent.com/your-repo/catpaw/main/install.sh | bash -s -- --silent
```

### 指定版本安装

```bash
# 安装特定版本
git clone -b v0.2.0 https://github.com/your-repo/catpaw.git ~/catpaw
cd ~/catpaw
./install.sh
```

### 离线安装

```bash
# 1. 下载代码包
wget https://github.com/your-repo/catpaw/archive/main.zip
unzip main.zip
cd catpaw-main

# 2. 离线安装依赖
pip3 download -r requirements.txt
pip3 install --no-index --find-links=. -r requirements.txt

# 3. 运行安装脚本
./install.sh --offline
```

---

## 📞 获取帮助

```bash
# 查看帮助
catpaw help

# 查看版本
catpaw --version

# 查看文档
cat ~/catpaw/QUICKSTART.md
```

---

## 🎉 安装完成检查清单

- [ ] ✅ 代码已克隆到 ~/catpaw
- [ ] ✅ Python 依赖已安装
- [ ] ✅ LLM 配置已保存 (~/.catpaw/llm_config.json)
- [ ] ✅ `catpaw` 命令可用
- [ ] ✅ 可以正常启动 CLI 或 Web

---

**现在 CatPaw 也可以一键安装了！** 🚀

就像 CoPaw 和 OpenCat 一样简单！
