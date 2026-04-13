#!/usr/bin/env python3
"""
CatPaw 实时信息查询模块 - 增强版
支持任意城市天气查询、时间日期等实时信息
"""

from datetime import datetime
import subprocess
import json
import re

# 中国主要城市字典（中文 -> 英文）
CHINA_CITIES = {
    # 直辖市
    "北京": "Beijing", "上海": "Shanghai", "天津": "Tianjin", "重庆": "Chongqing",
    # 东北地区
    "通化": "Tonghua", "吉林": "Jilin", "长春": "Changchun", "哈尔滨": "Harbin",
    "沈阳": "Shenyang", "大连": "Dalian", "鞍山": "Anshan", "抚顺": "Fushun",
    "本溪": "Benxi", "丹东": "Dandong", "锦州": "Jinzhou", "营口": "Yingkou",
    "阜新": "Fuxin", "辽阳": "Liaoyang", "盘锦": "Panjin", "铁岭": "Tieling",
    "朝阳": "Chaoyang", "葫芦岛": "Huludao", "白城": "Baicheng", "白山": "Baishan",
    "松原": "Songyuan", "四平": "Siping", "辽源": "Liaoyuan", "延边": "Yanbian",
    "大庆": "Daqing", "齐齐哈尔": "Qiqihar", "牡丹江": "Mudanjiang",
    "佳木斯": "Jiamusi", "鸡西": "Jixi", "鹤岗": "Hegang", "双鸭山": "Shuangyashan",
    "伊春": "Yichun", "七台河": "Qitaihe", "黑河": "Heihe", "绥化": "Suihua",
    # 省会城市
    "石家庄": "Shijiazhuang", "太原": "Taiyuan", "西安": "Xian", "济南": "Jinan",
    "郑州": "Zhengzhou", "合肥": "Hefei", "南京": "Nanjing", "杭州": "Hangzhou",
    "武汉": "Wuhan", "长沙": "Changsha", "南昌": "Nanchang", "福州": "Fuzhou",
    "广州": "Guangzhou", "海口": "Haikou", "南宁": "Nanning", "成都": "Chengdu",
    "贵阳": "Guiyang", "昆明": "Kunming", "拉萨": "Lhasa", "西宁": "Xining",
    "银川": "Yinchuan", "乌鲁木齐": "Urumqi", "呼和浩特": "Hohhot",
    # 计划单列市
    "青岛": "Qingdao", "宁波": "Ningbo", "厦门": "Xiamen", "深圳": "Shenzhen",
    # 其他重要城市
    "苏州": "Suzhou", "无锡": "Wuxi", "常州": "Changzhou", "南通": "Nantong",
    "徐州": "Xuzhou", "温州": "Wenzhou", "东莞": "Dongguan", "佛山": "Foshan",
    "中山": "Zhongshan", "珠海": "Zhuhai", "汕头": "Shantou", "湛江": "Zhanjiang",
    "烟台": "Yantai", "潍坊": "Weifang", "淄博": "Zibo", "威海": "Weihai",
    "日照": "Rizhao", "临沂": "Linyi", "泉州": "Quanzhou", "漳州": "Zhangzhou",
    "莆田": "Putian", "洛阳": "Luoyang", "开封": "Kaifeng", "安阳": "Anyang",
    "桂林": "Guilin", "柳州": "Liuzhou", "北海": "Beihai", "三亚": "Sanya",
    "绵阳": "Mianyang", "德阳": "Deyang", "宜宾": "Yibin", "遵义": "Zunyi",
    "大理": "Dali", "丽江": "Lijiang", "唐山": "Tangshan", "保定": "Baoding",
    "廊坊": "Langfang", "沧州": "Cangzhou", "邯郸": "Handan", "宝鸡": "Baoji",
    "咸阳": "Xianyang", "赣州": "Ganzhou", "宜昌": "Yichang", "襄阳": "Xiangyang",
    "荆州": "Jingzhou", "岳阳": "Yueyang", "常德": "Changde", "株洲": "Zhuzhou",
    "湘潭": "Xiangtan", "衡阳": "Hengyang"
}


def get_current_time_info():
    """获取当前时间信息"""
    now = datetime.now()
    weekday_map = {
        "0": "星期日", "1": "星期一", "2": "星期二",
        "3": "星期三", "4": "星期四", "5": "星期五", "6": "星期六"
    }
    return {
        "success": True,
        "datetime": now.strftime("%Y-%m-%d %H:%M:%S"),
        "date": now.strftime("%Y年%m月%d日"),
        "time": now.strftime("%H:%M:%S"),
        "weekday": now.strftime("%A"),
        "weekday_cn": weekday_map.get(now.strftime("%w"), ""),
        "timezone": "Asia/Shanghai (CST)",
        "timestamp": now.isoformat()
    }


def get_weather_city(city="北京"):
    """
    获取任意城市天气信息（使用 wttr.in API）
    支持中文城市名和拼音
    """
    try:
        # 获取城市英文名
        city_en = CHINA_CITIES.get(city, city)
        
        # 使用 wttr.in API（支持全球城市）
        response = subprocess.run(
            ['curl', '-s', '--max-time', '15', '-A', 'Mozilla/5.0',
             f'https://wttr.in/{city_en}?format=j1&lang=zh'],
            capture_output=True,
            text=True,
            timeout=20
        )
        
        if response.returncode == 0 and response.stdout.strip():
            data = json.loads(response.stdout)
            
            if 'current_condition' in data and len(data['current_condition']) > 0:
                current = data['current_condition'][0]
                
                return {
                    "success": True,
                    "city": city,
                    "city_en": city_en,
                    "temp_c": current.get('temp_C', 'N/A'),
                    "temp_f": current.get('temp_F', 'N/A'),
                    "weather": current.get('weatherDesc', [{}])[0].get('value', 'N/A'),
                    "weather_cn": current.get('weatherDesc', [{}])[0].get('value', 'N/A'),
                    "humidity": current.get('humidity', 'N/A'),
                    "wind_kmph": current.get('windspeedKmph', 'N/A'),
                    "wind_dir": current.get('winddir16Point', 'N/A'),
                    "pressure": current.get('pressure', 'N/A'),
                    "feels_like_c": current.get('FeelsLikeC', 'N/A'),
                    "visibility": current.get('visibility', 'N/A'),
                    "uv_index": current.get('uvIndex', 'N/A')
                }
        
        return {"success": False, "error": f"无法获取 {city} 的天气信息"}
        
    except subprocess.TimeoutExpired:
        return {"success": False, "error": "天气查询超时（20 秒）"}
    except json.JSONDecodeError:
        return {"success": False, "error": "解析天气数据失败"}
    except Exception as e:
        return {"success": False, "error": f"天气查询错误：{str(e)}"}


def extract_city_from_query(query):
    """
    从查询中提取城市名称
    """
    query_lower = query.lower()
    
    # 按长度降序匹配（避免"北京"匹配到"北京市"）
    sorted_cities = sorted(CHINA_CITIES.keys(), key=len, reverse=True)
    
    for city in sorted_cities:
        if city in query or city.lower() in query_lower:
            return city
    
    # 匹配"XX 市"格式
    match = re.search(r'([\u4e00-\u9fa5]{2,4}) 市', query)
    if match:
        potential_city = match.group(1)
        for city in CHINA_CITIES.keys():
            if potential_city in city or city in potential_city:
                return city
    
    return None


def should_search(query):
    """判断查询是否需要实时信息"""
    query_lower = query.lower()
    
    time_keywords = [
        "现在几点", "当前时间", "今天", "明天", "昨天", "日期", "星期",
        "现在时间", "几点钟", "什么时间", "时间", "时刻",
        "今年", "本月", "几号", "周几", "礼拜"
    ]
    for keyword in time_keywords:
        if keyword in query_lower:
            return "time"
    
    weather_keywords = [
        "天气", "气温", "预报", "下雨", "晴天", "温度",
        "几度", "冷热", "雾霾", "空气质量", "湿度",
        "刮风", "台风", "降雪", "阴天", "多云", "气候"
    ]
    for keyword in weather_keywords:
        if keyword in query_lower:
            return "weather"
    
    search_keywords = [
        "新闻", "最新", "最近", "股价", "股票", "汇率",
        "比赛", "比分", "地震", "疫情", "今日",
        "动态", "进展", "突发", "快讯", "消息"
    ]
    for keyword in search_keywords:
        if keyword in query_lower:
            return "search"
    
    if "?" in query or "？" in query:
        return "search"
    
    return None


def get_realtime_context(query):
    """根据查询类型获取实时信息上下文"""
    search_type = should_search(query)
    
    if search_type == "time":
        time_info = get_current_time_info()
        if time_info.get("success"):
            return f"""【当前时间信息】
日期：{time_info['date']} {time_info['weekday_cn']}
时间：{time_info['time']}
时区：{time_info['timezone']}

"""
    
    elif search_type == "weather":
        city = extract_city_from_query(query)
        
        if not city:
            city = "北京"
        
        weather_info = get_weather_city(city)
        
        if weather_info.get("success"):
            return f"""【{weather_info['city']}实时天气】
🌡️ 温度：{weather_info['temp_c']}°C (体感{weather_info['feels_like_c']}°C)
🌤️ 天气：{weather_info['weather_cn']}
💧 湿度：{weather_info['humidity']}%
🍃 风向：{weather_info['wind_dir']}，风速：{weather_info['wind_kmph']} km/h
👁️ 能见度：{weather_info['visibility']} km
☀️ 紫外线：{weather_info['uv_index']}

"""
        else:
            return f"""【天气查询失败】
城市：{city}
原因：{weather_info.get('error', '未知错误')}
建议：请检查城市名称是否正确，或稍后重试。

"""
    
    return ""


if __name__ == "__main__":
    print("=" * 60)
    print("CatPaw 实时信息查询模块 - 增强版测试")
    print("=" * 60)
    
    print("\n🌤️  测试城市天气查询:")
    test_cities = ["北京天气", "上海气温", "通化天气", "广州天气", "深圳天气"]
    
    for query in test_cities:
        print(f"\n查询：{query}")
        context = get_realtime_context(query)
        if context:
            print(context)
        else:
            print("  ❌ 未识别为天气查询")
    
    print("\n✅ 测试完成!")
