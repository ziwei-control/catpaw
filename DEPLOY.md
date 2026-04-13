# 🚀 CatPaw 一键部署指南

**更新时间**: 2026-04-12  
**版本**: v0.3.0

---

## 🎯 快速部署 (3 分钟)

### 方式 1: 全新部署 (推荐)

```bash
# 一键部署脚本
curl -fsSL https://gitee.com/pandac0/catpaw/raw/main/deploy.sh | bash

# 或使用 GitHub
curl -fsSL https://raw.githubusercontent.com/ziwei-control/catpaw/main/deploy.sh | bash
```

### 方式 2: 手动部署

```bash
# 1. 克隆仓库
git clone https://gitee.com/pandac0/catpaw.git
cd catpaw

# 2. 运行部署脚本
chmod +x deploy.sh
./deploy.sh
```

---

## 📋 部署步骤详解

### 步骤 1: 下载部署脚本

```bash
# 从 Gitee 下载 (国内推荐)
wget https://gitee.com/pandac0/catpaw/raw/main/deploy.sh

# 或从 GitHub 下载
wget https://raw.githubusercontent.com/ziwei-control/catpaw/main/deploy.sh
```

### 步骤 2: 执行部署

```bash
chmod +x deploy.sh
./deploy.sh
```

### 步骤 3: 按提示配置

部署脚本会自动：

1. ✅ 检查系统要求 (Python, Git, pip)
2. ✅ 克隆代码
3. ✅ 安装依赖
4. ✅ 配置 LLM (可选)
5. ✅ 配置防火墙
6. ✅ 配置系统服务 (可选)
7. ✅ 启动服务

---

## 🔧 部署选项

### 环境变量配置

```bash
# 自定义安装目录
INSTALL_DIR=/opt/catpaw ./deploy.sh

# 指定代码源
REPO_SOURCE=github ./deploy.sh  # GitHub
REPO_SOURCE=gitee ./deploy.sh   # Gitee

# 指定 Python
PYTHON_CMD=python3.11 ./deploy.sh
```

### 非交互式部署

```bash
# 自动确认所有提示
yes | ./deploy.sh

# 或使用环境变量
export REPO_SOURCE=gitee
export INSTALL_DIR=/home/admin/projects/catpaw
./deploy.sh
```

---

## 🎯 部署后操作

### 访问 Web 界面

```
本地：http://localhost:6767
局域网：http://你的IP:6767
```

### 配置 LLM

如果部署时跳过了 LLM 配置：

```bash
# 方式 1: 网页配置
# 访问 http://localhost:6767
# 点击 ⚙️ 配置

# 方式 2: 命令行配置
cd /home/admin/projects/catpaw
python3 configure_llm.py
```

### 配置系统服务

如果部署时未配置开机自启：

```bash
cd /home/admin/projects/catpaw
sudo ./deploy.sh  # 重新运行，选择配置服务
```

或手动配置：

```bash
# 创建服务文件
sudo cp catpaw.service.template /etc/systemd/system/catpaw.service

# 替换变量
sudo sed -i "s/%USER%/$USER/g" /etc/systemd/system/catpaw.service
sudo sed -i "s|%INSTALL_DIR%|$(pwd)|g" /etc/systemd/system/catpaw.service
sudo sed -i "s|%PYTHON%|$(which python3)|g" /etc/systemd/system/catpaw.service

# 启用服务
sudo systemctl daemon-reload
sudo systemctl enable catpaw
sudo systemctl start catpaw
```

---

## 🔄 更新 CatPaw

### 一键更新

```bash
cd /home/admin/projects/catpaw
./update.sh
```

### 手动更新

```bash
cd /home/admin/projects/catpaw

# 拉取更新
git pull

# 安装新依赖
pip3 install -r requirements.txt

# 重启服务
./stop.sh
./start.sh
```

---

## 📊 系统服务管理

### 查看状态

```bash
sudo systemctl status catpaw
```

### 启动/停止/重启

```bash
sudo systemctl start catpaw
sudo systemctl stop catpaw
sudo systemctl restart catpaw
```

### 查看日志

```bash
# 系统日志
sudo journalctl -u catpaw -f

# 应用日志
tail -f /home/admin/projects/catpaw/logs/web.log
```

### 禁用开机自启

```bash
sudo systemctl disable catpaw
```

---

## 🛡️ 安全配置

### 防火墙配置

```bash
# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=6767/tcp
sudo firewall-cmd --reload

# Ubuntu
sudo ufw allow 6767/tcp
```

### 云服务器安全组

**阿里云**:
1. 登录 ECS 控制台
2. 安全组 → 配置规则
3. 添加入站规则：端口 6767/TCP

**腾讯云**:
1. 登录 CVM 控制台
2. 安全组 → 规则管理
3. 添加入站规则：端口 6767/TCP

### 使用 HTTPS (推荐)

```bash
# 安装 Nginx
sudo yum install nginx -y  # CentOS
sudo apt install nginx -y  # Ubuntu

# 配置反向代理
sudo cat > /etc/nginx/conf.d/catpaw.conf << 'EOF'
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://127.0.0.1:6767;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

# 申请 SSL 证书 (Let's Encrypt)
sudo yum install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

---

## 🐛 故障排除

### 问题 1: 部署失败

```bash
# 查看详细日志
./deploy.sh 2>&1 | tee deploy.log

# 检查系统要求
python3 --version
git --version
pip3 --version
```

### 问题 2: 服务无法启动

```bash
# 检查端口占用
netstat -tlnp | grep 6767

# 检查日志
tail -f logs/web.log

# 手动启动测试
python3 web_server.py --port 6767
```

### 问题 3: 无法访问网页

```bash
# 检查服务状态
ps aux | grep web_server

# 检查防火墙
sudo firewall-cmd --list-all

# 检查安全组 (云服务器)
# 登录云控制台确认 6767 端口已开放
```

### 问题 4: 依赖安装失败

```bash
# 升级 pip
pip3 install --upgrade pip

# 手动安装依赖
pip3 install flask flask-cors requests
```

---

## 📁 目录结构

```
/home/admin/projects/catpaw/
├── deploy.sh              # 部署脚本 ⭐
├── update.sh              # 更新脚本 ⭐
├── start.sh               # 启动脚本
├── stop.sh                # 停止脚本
├── catpaw.service.template  # systemd 模板
├── requirements.txt       # Python 依赖
├── .env.example          # 环境变量示例
├── web_server.py         # Web 服务器
├── catpaw.py          # 主程序
├── workspace/            # 工作空间
├── logs/                 # 日志目录
└── ...
```

---

## 💡 最佳实践

### 1. 生产环境部署

```bash
# 使用专用用户
sudo useradd -m catpaw
sudo usermod -aG sudo catpaw

# 切换到 catpaw 用户
sudo su - catpaw

# 部署
cd /home/catpaw
curl -fsSL https://gitee.com/pandac0/catpaw/raw/main/deploy.sh | bash
```

### 2. 备份配置

```bash
# 备份重要配置
tar -czf catpaw-backup-$(date +%Y%m%d).tar.gz \
    ~/.catpaw/llm_config.json \
    workspace/
```

### 3. 监控服务

```bash
# 创建监控脚本
cat > /usr/local/bin/check-catpaw.sh << 'EOF'
#!/bin/bash
if ! pgrep -f "web_server.py.*6767" > /dev/null; then
    echo "CatPaw 服务异常，尝试重启..."
    sudo systemctl restart catpaw
    echo "$(date): CatPaw restarted" >> /var/log/catpaw-monitor.log
fi
EOF

chmod +x /usr/local/bin/check-catpaw.sh

# 添加到 crontab
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/check-catpaw.sh") | crontab -
```

---

## 📞 需要帮助？

### 文档

- [README.md](README.md) - 项目总览
- [QUICKSTART.md](QUICKSTART.md) - 快速开始
- [COMPLETE_GUIDE.md](COMPLETE_GUIDE.md) - 完整指南
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - 故障排除

### 社区

- **GitHub**: https://github.com/ziwei-control/catpaw
- **Gitee**: https://gitee.com/pandac0/catpaw
- **Issues**: 提交问题反馈

---

## ✅ 部署检查清单

- [ ] 系统要求检查 (Python 3, Git, pip)
- [ ] 代码克隆完成
- [ ] 依赖安装完成
- [ ] LLM 配置完成
- [ ] 防火墙配置完成
- [ ] 服务启动成功
- [ ] 网页可以访问
- [ ] 配置开机自启 (可选)

---

**部署愉快！** 🎉

**最后更新**: 2026-04-12  
**版本**: v0.3.0
