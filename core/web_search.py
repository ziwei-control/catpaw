#!/usr/bin/env python3
"""
CatPaw 网络搜索模块
提供实时信息查询功能
"""

import requests
import json
from datetime import datetime
import os
import subprocess

def tavily_search(query, max_results=5, search_depth="basic", time_range=None):
    """
    使用 Tavily API 进行网络搜索
    """
    api_key = os.environ.get('TAVILY_API_KEY', '')
    
    if not api_key:
        # 没有 API Key，使用简单搜索
        return simple_search(query, max_results)
    
    try:
        url = "https://api.tavily.com/v1/search"
        headers = {"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"}
        payload = {
            "query": query,
            "max_results": max_results,
            "search_depth": search_depth,
            "include_answer": True,
        }
        if time_range:
            payload["time_range"] = time_range
        
        response = requests.post(url, headers=headers, json=payload, timeout=30)
        response.raise_for_status()
        result = response.json()
        
        formatted_results = []
        for item in result.get("results", []):
            formatted_results.append({
                "title": item.get("title", ""),
                "content": item.get("content", ""),
                "url": item.get("url", ""),
                "published_date": item.get("published_date", "")
            })
        
        return {
            "success": True,
            "answer": result.get("answer", ""),
            "results": formatted_results,
            "query": query,
            "timestamp": datetime.now().isoformat(),
            "method": "tavily"
        }
    except Exception as e:
        return simple_search(query, max_results)


def simple_search(query, max_results=5):
    """
    简单搜索实现（使用 curl + 搜索引擎）
    """
    try:
        # 使用 Bing 搜索（相对容易抓取）
        search_url = f"https://www.bing.com/search?q={query}&count={max_results}"
        
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
            "Accept": "text/html,application/xhtml+xml"
        }
        
        response = subprocess.run(
            ['curl', '-s', '--max-time', '15', '-A', headers["User-Agent"], search_url],
            capture_output=True,
            text=True,
            timeout=20
        )
        
        if response.returncode == 0:
            html = response.stdout
            
            # 简单解析搜索结果
            results = []
            # 查找标题和链接
            import re
            title_pattern = r'<h2[^>]*><a[^>]*href="([^"]+)"[^>]*>([^<]+)</a>'
            matches = re.findall(title_pattern, html, re.IGNORECASE)
            
            for url, title in matches[:max_results]:
                if url.startswith('http') and 'bing.com' not in url:
                    results.append({
                        "title": title.strip(),
                        "content": "",
                        "url": url,
                        "published_date": ""
                    })
            
            if results:
                return {
                    "success": True,
                    "answer": f"找到 {len(results)} 条相关信息",
                    "results": results,
                    "query": query,
                    "timestamp": datetime.now().isoformat(),
                    "method": "bing_curl"
                }
        
        return {
            "success": False,
            "error": "无法获取搜索结果",
            "results": [],
            "method": "bing_curl"
        }
        
    except Exception as e:
        return {
            "success": False,
            "error": f"搜索失败：{str(e)}",
            "results": [],
            "method": "simple"
        }


def should_search(query):
    """
    判断查询是否需要网络搜索
    """
    query_lower = query.lower()
    
    time_keywords = [
        "现在几点", "当前时间", "今天", "明天", "昨天",
        "天气", "气温", "预报",
        "新闻", "最新", "最近", "刚刚",
        "股价", "股票", "汇率", "比特币",
        "比赛", "比分", "赛果",
        "疫情", "病毒", "确诊",
        "地震", "台风", "灾害",
        "选举", "投票", "民调",
        "排行榜", "排名", "榜单",
        "价格", "多少钱", "售价",
        "谁赢了", "谁输了", "结果",
        "当前", "实时", "此刻",
        "2025", "2026", "2027"
    ]
    
    for keyword in time_keywords:
        if keyword in query_lower:
            return True
    
    if "?" in query or "？" in query:
        return True
    
    info_keywords = ["是什么", "为什么", "怎么样", "如何做", "怎么做", "在哪里"]
    for keyword in info_keywords:
        if keyword in query_lower:
            return True
    
    return False


def format_search_context(search_result):
    """
    将搜索结果格式化为 LLM 上下文
    """
    if not search_result.get("success"):
        return ""
    
    context_parts = ["【网络实时信息】"]
    
    if search_result.get("answer"):
        context_parts.append(search_result['answer'])
    
    results = search_result.get("results", [])
    if results:
        context_parts.append("\n相关信息:")
        for i, item in enumerate(results, 1):
            context_parts.append(f"{i}. {item['title']} - {item['url']}")
    
    return "\n".join(context_parts) + "\n"


if __name__ == "__main__":
    print("🔍 测试网络搜索...")
    result = tavily_search("2026 AI 新闻")
    print(json.dumps(result, indent=2, ensure_ascii=False)[:500])
