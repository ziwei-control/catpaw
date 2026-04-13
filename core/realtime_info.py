#!/usr/bin/env python3
"""
CatPaw 实时信息查询模块
提供时间、日期等基础实时信息查询
"""

from datetime import datetime
import subprocess
import json

def get_current_time_info():
    """
    获取当前时间信息
    Returns: dict with time info
    """
    now = datetime.now()
    return {
        "success": True,
        "datetime": now.strftime("%Y-%m-%d %H:%M:%S"),
        "date": now.strftime("%Y年%m月%d日"),
        "time": now.strftime("%H:%M:%S"),
        "weekday": now.strftime("%A"),
        "weekday_cn": now.strftime("%w"),
        "timezone": "Asia/Shanghai (CST)",
        "timestamp": now.isoformat()
    }


def get_weather_city(city="北京"):
    """
    获取天气信息（使用 curl + 天气 API）
    """
    try:
        # 使用 open-meteo 免费天气 API
        # 需要先获取城市坐标，这里简化处理
        response = subprocess.run(
            ['curl', '-s', '--max-time', '10', 
             f'https://wttr.in/{city}?format=j1'],
            capture_output=True,
            text=True,
            timeout=15
        )
        
        if response.returncode == 0:
            data = json.loads(response.stdout)
            current = data.get('current_condition', [{}])[0]
            return {
                "success": True,
                "city": city,
                "temp_c": current.get('temp_C', 'N/A'),
                "temp_f": current.get('temp_F', 'N/A'),
                "weather": current.get('weatherDesc', [{}])[0].get('value', 'N/A'),
                "humidity": current.get('humidity', 'N/A'),
                "wind_kmph": current.get('windspeedKmph', 'N/A')
            }
    except:
        pass
    
    return {"success": False, "error": "无法获取天气信息"}


def should_search(query):
    """
    判断查询是否需要实时信息
    """
    query_lower = query.lower()
    
    # 时间相关 - 扩展关键词
    time_keywords = [
        "现在几点", "当前时间", "今天", "明天", "昨天", "日期", "星期",
        "现在时间", "几点钟", "什么时间", "时间", "时刻",
        "今年", "本月", "几号", "周几", "礼拜"
    ]
    for keyword in time_keywords:
        if keyword in query_lower:
            return "time"
    
    # 天气相关 - 扩展关键词
    weather_keywords = [
        "天气", "气温", "预报", "下雨", "晴天", "温度",
        "几度", "冷热", "雾霾", "空气质量", "湿度",
        "刮风", "台风", "降雪", "阴天", "多云"
    ]
    for keyword in weather_keywords:
        if keyword in query_lower:
            return "weather"
    
    # 其他需要网络搜索的
    search_keywords = [
        "新闻", "最新", "最近", "股价", "股票", "汇率",
        "比赛", "比分", "地震", "疫情", "今日",
        "动态", "进展", "突发", "快讯", "消息"
    ]
    for keyword in search_keywords:
        if keyword in query_lower:
            return "search"
    
    # 问题形式
    if "?" in query or "？" in query:
        return "search"
    
    return None


def get_realtime_context(query):
    """
    根据查询类型获取实时信息上下文
    Returns: str - 格式化的上下文文本
    """
    search_type = should_search(query)
    
    if search_type == "time":
        time_info = get_current_time_info()
        if time_info.get("success"):
            weekday_map = {
                "0": "星期日", "1": "星期一", "2": "星期二",
                "3": "星期三", "4": "星期四", "5": "星期五", "6": "星期六"
            }
            weekday_cn = weekday_map.get(time_info["weekday_cn"], "")
            return f"""【当前时间信息】
日期：{time_info['date']} {weekday_cn}
时间：{time_info['time']}
时区：{time_info['timezone']}

"""
    
    elif search_type == "weather":
        # 尝试从查询中提取城市
        cities = ["北京", "上海", "广州", "深圳", "杭州", "成都", "武汉", "西安", "南京", "苏州"]
        city = "北京"
        for c in cities:
            if c in query:
                city = c
                break
        
        weather_info = get_weather_city(city)
        if weather_info.get("success"):
            return f"""【{city}天气信息】
温度：{weather_info['temp_c']}°C ({weather_info['temp_f']}°F)
天气：{weather_info['weather']}
湿度：{weather_info['humidity']}%
风速：{weather_info['wind_kmph']} km/h

"""
    
    return ""


if __name__ == "__main__":
    print("🕐 测试时间查询...")
    print(get_realtime_context("现在几点"))
    
    print("\n🌤️  测试天气查询...")
    print(get_realtime_context("北京天气怎么样"))
    
    print("\n🔍 测试搜索类型判断...")
    test_queries = ["现在几点", "北京天气", "最新新闻", "你好"]
    for q in test_queries:
        print(f"  '{q}' -> {should_search(q)}")
