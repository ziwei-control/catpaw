#!/usr/bin/env python3
"""
CatPaw 实时信息功能演示
（不依赖 LLM API，仅展示实时信息获取能力）
"""

import sys
sys.path.insert(0, '/root/.copaw/workspaces/default/catpaw')

from core.realtime_info import get_realtime_context, should_search

def demo():
    print("""
    ╔═══════════════════════════════════════╗
    ║   CatPaw 实时信息功能演示           ║
    ║   (不依赖 LLM API)                     ║
    ╚═══════════════════════════════════════╝
    """)
    
    test_cases = [
        ("现在几点？", "time"),
        ("今天星期几？", "time"),
        ("北京天气怎么样？", "weather"),
        ("上海天气", "weather"),
        ("你好", None),
        ("什么是 AI？", "search"),
    ]
    
    for query, expected_type in test_cases:
        print(f"\n{'='*60}")
        print(f" 用户问：{query}")
        print(f"{'='*60}")
        
        # 检测查询类型
        search_type = should_search(query)
        print(f"\n🔍 识别类型：{search_type}")
        
        # 获取实时信息
        context = get_realtime_context(query)
        
        if context:
            print(f"\n✅ 已获取实时信息:")
            print("-" * 60)
            print(context)
            print("-" * 60)
            print(f"\n💡 这些实时信息将自动添加到 LLM 的上下文中")
        else:
            print(f"\nℹ️  无需实时信息，使用普通对话模式")
    
    print("\n\n✅ 演示完成！")
    print("\n📝 工作原理:")
    print("   1. 用户发送消息 → /api/chat")
    print("   2. 系统分析是否需要实时信息")
    print("   3. 自动获取时间/天气等实时数据")
    print("   4. 将实时信息添加到 LLM 上下文")
    print("   5. LLM 基于实时信息生成回答")
    print("\n🔧 配置 LLM API Key 后即可使用完整功能")
    print("   详见：catpaw/NETWORK_SEARCH_SETUP.md")

if __name__ == "__main__":
    demo()
