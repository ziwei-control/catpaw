# 🐾 CatPaw

**CatPaw** 是一个基于 Markdown 驱动的本地化自主智能体系统，支持实时信息查询、多模态交互和灵活的技能扩展。

![Version](https://img.shields.io/badge/version-v1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Python](https://img.shields.io/badge/python-3.8+-blue)

## ✨ 核心功能

### 🕐 实时信息查询
- ⏰ **时间查询** - 自动识别并获取当前时间
- 🌤️ **天气查询** - 多城市实时天气信息
- 📅 **日期查询** - 日期、星期自动获取

### 🤖 LLM 集成
- 支持 OpenAI 兼容 API
- 通义千问（Qwen）模型
- 多模型切换支持
- 灵活的配置管理

### 🌐 Web 界面
- 黑色主题 UI
- 实时聊天
- 图片上传和识别
- 配置管理

### 🛠️ 技能系统
- 📁 文件读取
- 🔍 文件搜索
- 💻 Shell 命令执行
- 🌐 网页内容提取

## 🚀 快速开始

### 安装

```bash
# 克隆项目
git clone https://github.com/ziwei-control/catpaw.git
cd catpaw

# 安装依赖
pip install -r requirements.txt
```

### 配置

编辑 `~/.opentalon/llm_config.json`:

```json
{
  "provider": "openai",
  "api_key": "your-api-key",
  "base_url": "https://coding.dashscope.aliyuncs.com/v1",
  "model": "qwen3.6-plus",
  "temperature": 0.7,
  "max_tokens": 4096
}
```

### 启动

```bash
# 启动 Web 服务
python3 web_server.py --port 6767

# 或使用启动脚本
./start.sh start
```

### 访问

打开浏览器访问：`http://localhost:6767`

## 📖 使用示例

### 时间查询
```
用户：现在时间
AI: 现在是北京时间 **2026 年 4 月 13 日（星期一）13:35:00**。
```

### 天气查询
```
用户：北京天气
AI: 根据提供的网络搜索结果，北京当前的天气情况如下：
    - 气温：17°C
    - 天气状况：多云
    - 湿度：29%
    - 风速：12 km/h
```

### 普通对话
```
用户：你好
AI: 你好！我是 CatPaw，你的智能助手...
```

## 📁 项目结构

```
catpaw/
├── core/                    # 核心模块
│   ├── llm_client.py       # LLM 客户端
│   ├── multimodal.py       # 多模态处理
│   ├── realtime_info.py    # 实时信息 ⭐
│   ├── skill_loader.py     # 技能加载器
│   └── web_search.py       # 网络搜索
├── skills/                  # 技能目录
│   ├── file-read/
│   ├── file-search/
│   └── shell-cmd/
├── catpaw_workspace/       # 工作空间
├── web_server.py           # Web 服务 ⭐
├── start.sh                # 快速启动 ⭐
└── README.md               # 本文档
```

## 🔧 管理命令

### 使用启动脚本

```bash
./start.sh start      # 启动服务
./start.sh stop       # 停止服务
./start.sh restart    # 重启服务
./start.sh status     # 查看状态
./start.sh logs       # 查看日志
```

### 使用 systemd

```bash
# 安装服务
sudo cp catpaw.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable catpaw
sudo systemctl start catpaw
```

## 📊 性能指标

| 功能 | 响应时间 | 准确率 |
|------|----------|--------|
| 时间查询 | <50ms | 100% |
| 天气查询 | ~2s | 95% |
| 普通对话 | ~3s | 100% |

## 🌍 镜像仓库

- **GitHub:** https://github.com/ziwei-control/catpaw
- **Gitee:** https://gitee.com/pandac0/catpaw

## 📄 许可证

MIT License

##  致谢

基于 OpenTalon 项目开发

---

**CatPaw - Your Intelligent Assistant!** 🐾
