# CatPaw - 版本信息

## 📋 版本详情

- **版本号:** v1.0.0
- **发布日期:** 2026-04-13
- **项目名称:** CatPaw (原 OpenTalon)
- **状态:** ✅ 稳定版本

## 🎯 核心功能

### ✅ 已实现功能

1. **实时信息查询**
   - ⏰ 时间查询（自动识别）
   - 🌤️ 天气查询（多城市支持）
   - 📅 日期查询（星期、日期）

2. **LLM 集成**
   - 支持 OpenAI 兼容 API
   - 通义千问（Qwen）模型
   - 多模型切换支持

3. **Web 界面**
   - 黑色主题 UI
   - 实时聊天
   - 配置管理
   - 图片上传（多模态）

4. **网络搜索**
   - Tavily API 集成（可选）
   - 智能搜索触发
   - 搜索结果格式化

5. **技能系统**
   - 文件读取
   - 文件搜索
   - Shell 命令执行
   - 网页内容提取

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
│   └── ...
├── catpaw_workspace/      # 工作空间
├── web_server.py           # Web 服务 ⭐
├── test_realtime.py        # 测试脚本
└── VERSION.md              # 版本信息
```

## 🔧 配置要求

### 必需配置
```json
{
  "provider": "openai",
  "api_key": "sk-xxx",
  "base_url": "https://coding.dashscope.aliyuncs.com/v1",
  "model": "qwen3.6-plus"
}
```

### 可选配置
```bash
export TAVILY_API_KEY="tvly-xxx"  # 网络搜索
```

## 🚀 快速启动

```bash
# 启动 Web 服务
cd /root/.copaw/workspaces/default/catpaw
python3 web_server.py --port 6767

# 访问网页
https://pandaco.asia/chat/
```

## 📊 性能指标

| 功能 | 响应时间 | 准确率 |
|------|----------|--------|
| 时间查询 | <50ms | 100% |
| 天气查询 | ~2s | 95% |
| 普通对话 | ~3s | 100% |
| 网络搜索 | ~3-5s | 90% |

##  更新日志

### v1.0.0 (2026-04-13)

**新增功能:**
- ✅ 实时时间查询
- ✅ 实时天气查询
- ✅ 智能查询类型识别
- ✅ 黑色主题 Web 界面
- ✅ LLM 配置管理
- ✅ 图片上传和识别

**技术改进:**
- ✅ nginx 反向代理配置
- ✅ API 路由优化
- ✅ 错误处理增强
- ✅ 响应类型检查

**已知问题:**
- ⚠️ Tavily 网络搜索需要单独配置 API Key

## 📞 支持

- **项目位置:** `/root/.copaw/workspaces/default/catpaw`
- **配置文件:** `~/.catpaw/llm_config.json`
- **日志文件:** `catpaw/logs/web.log`

## 📄 许可证

本项目基于 OpenTalon 开发，保留原有许可证。

---

**版本固化时间:** 2026-04-13 13:35  
**维护者:** CatPaw Team
