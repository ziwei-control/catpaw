# CatPaw 网络搜索功能配置指南

## ✅ 已完成的配置

### 1. 访问地址
```
https://pandaco.asia/chat/
```
nginx 已配置反向代理到 catpaw 服务（端口 6767）

### 2. 实时信息功能
已集成以下实时信息查询：

| 功能 | 状态 | 说明 |
|------|------|------|
| **时间查询** | ✅ 已启用 | 自动识别"现在几点"、"今天日期"等 |
| **天气查询** | ✅ 已启用 | 自动识别"天气"、"气温"等关键词 |
| **网络搜索** | ⚠️ 需配置 API Key | 需要 Tavily API Key |

### 3. 新增文件
```
catpaw/core/realtime_info.py    # 实时信息查询模块
catpaw/core/web_search.py       # 网络搜索模块
catpaw/test_realtime.py         # 测试脚本
```

---

## 🔧 配置 LLM API Key

当前 API Key 已失效，需要更新：

### 方法 1: 直接编辑配置文件

```bash
nano ~/.catpaw/llm_config.json
```

修改内容：
```json
{
  "api_key": "YOUR_NEW_API_KEY",
  "base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1",
  "model": "qwen-plus",
  "temperature": 0.7,
  "max_tokens": 4096
}
```

### 方法 2: 使用网页配置

访问 `https://pandaco.asia/chat/` → Settings → 配置 API Key

### 获取 API Key

**通义千问（推荐）:**
1. 访问 https://dashscope.console.aliyun.com/
2. 登录阿里云账号
3. 创建/获取 API Key
4. 复制到配置文件

**其他提供商:**
- DeepSeek: https://platform.deepseek.com/
- Moonshot (Kimi): https://platform.moonshot.cn/
- OpenAI: https://platform.openai.com/

---

## 🌐 配置 Tavily 网络搜索（可选）

如果需要完整的网络搜索功能（新闻、股票等）：

### 步骤 1: 获取 Tavily API Key

1. 访问 https://tavily.com/
2. 注册账号
3. 获取 API Key（免费额度：每月 1000 次搜索）

### 步骤 2: 设置环境变量

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export TAVILY_API_KEY="your-tavily-api-key"

# 或临时设置
export TAVILY_API_KEY="tvly-..."
```

### 步骤 3: 重启服务

```bash
pkill -f web_server.py
cd /root/.copaw/workspaces/default/catpaw
python3 web_server.py --port 6767 &
```

---

## 🧪 测试功能

### 测试实时信息

```bash
cd /root/.copaw/workspaces/default/catpaw
python3 test_realtime.py
```

### 手动测试 curl

```bash
# 时间查询
curl -X POST http://127.0.0.1:6767/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"现在几点","use_search":"auto"}'

# 天气查询
curl -X POST http://127.0.0.1:6767/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"北京天气怎么样","use_search":"auto"}'
```

---

## 📝 功能说明

### 自动触发规则

系统会自动识别以下类型的查询并触发实时信息：

**时间相关:**
- 现在几点
- 当前时间
- 今天/明天/昨天
- 日期/星期

**天气相关:**
- 天气
- 气温
- 预报
- 下雨/晴天

**需要网络搜索:**
- 新闻/最新
- 股价/股票
- 比赛/比分
- 地震/台风

### 工作原理

1. **用户发送消息** → `/api/chat`
2. **分析消息类型** → `should_search()` / `should_realtime_search()`
3. **获取实时信息** → `get_realtime_context()`
4. **构建增强提示** → 添加系统提示包含实时信息
5. **调用 LLM** → 返回带实时信息的回答

---

## 🎯 示例对话

**用户:** 现在几点？

**系统自动添加上下文:**
```
【当前时间信息】
日期：2026 年 04 月 13 日 星期一
时间：11:28:42
时区：Asia/Shanghai (CST)
```

**LLM 回答:**
现在是 2026 年 4 月 13 日星期一，北京时间 11:28:42。有什么我可以帮您的吗？

---

## 🔍 故障排除

### 问题 1: API Key 错误

**症状:** `401 Unauthorized` 或 `invalid_api_key`

**解决:**
1. 检查 `~/.catpaw/llm_config.json`
2. 确认 API Key 有效且未过期
3. 确认 base_url 正确

### 问题 2: 服务未启动

**症状:** 无法访问 `https://pandaco.asia/chat/`

**解决:**
```bash
# 检查服务状态
ps aux | grep web_server

# 重启服务
cd /root/.copaw/workspaces/default/catpaw
pkill -f web_server.py
python3 web_server.py --port 6767 &

# 查看日志
tail -f logs/web.log
```

### 问题 3: 实时信息不工作

**症状:** AI 仍然回答"无法获取时间"

**解决:**
1. 检查 `core/realtime_info.py` 是否存在
2. 检查 web_server.py 是否正确导入模块
3. 查看日志：`tail -f logs/web.log`

---

## 📚 相关文件

- `catpaw/web_server.py` - Web 服务主程序
- `catpaw/core/realtime_info.py` - 实时信息模块
- `catpaw/core/web_search.py` - 网络搜索模块
- `~/.catpaw/llm_config.json` - LLM 配置文件
- `/etc/nginx/conf.d/eat.conf` - nginx 反向代理配置

---

**更新时间:** 2026-04-13  
**维护者:** 如意 (Ruyi)
