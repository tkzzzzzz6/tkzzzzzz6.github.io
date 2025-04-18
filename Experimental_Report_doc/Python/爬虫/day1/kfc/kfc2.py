import urllib.request
import urllib.parse
import json
import time
import logging
from tqdm import tqdm
import os

# 配置日志
def setup_logger():
    """配置日志记录器"""
    # 创建logs目录（如果不存在）
    if not os.path.exists('logs'):
        os.makedirs('logs')
    
    # 配置日志格式
    log_format = '%(asctime)s - %(levelname)s - %(message)s'
    logging.basicConfig(
        level=logging.INFO,
        format=log_format,
        handlers=[
            logging.FileHandler(f'logs/kfc_crawler_{time.strftime("%Y%m%d_%H%M%S")}.log', encoding='utf-8'),
            logging.StreamHandler()
        ]
    )
    return logging.getLogger('kfc_crawler')

# 创建日志记录器
logger = setup_logger()

def get_all_cities():
    """获取所有城市列表"""
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"
    url = "https://www.kfc.com.cn/kfccda/ashx/GetStoreList.ashx?op=province"
    
    headers = {
        "User-Agent": user_agent,
        "Referer": "https://www.kfc.com.cn/kfccda/storelist/index.aspx",
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
        "Connection": "keep-alive",
        "X-Requested-With": "XMLHttpRequest"
    }
    
    try:
        logger.info("正在获取省份列表...")
        request = urllib.request.Request(url=url, headers=headers)
        response = urllib.request.urlopen(request)
        content = response.read().decode("utf-8")
        
        # 打印原始响应内容，用于调试
        logger.debug(f"API响应内容: {content[:100]}...")
        
        # 检查响应是否为空
        if not content.strip():
            logger.warning("API返回了空响应")
            return {"Table1": []}
            
        return json.loads(content)
    except json.JSONDecodeError as e:
        logger.error(f"JSON解析错误: {e}")
        logger.error(f"原始响应内容: {content}")
        return {"Table1": []}
    except Exception as e:
        logger.error(f"获取省份列表时出错: {e}")
        return {"Table1": []}

def get_cities_by_province(province_id, province_name):
    """根据省份ID获取城市列表"""
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"
    url = "https://www.kfc.com.cn/kfccda/ashx/GetStoreList.ashx?op=city"
    
    data = {
        "pid": province_id
    }
    
    data = urllib.parse.urlencode(data).encode("utf-8")
    headers = {
        "User-Agent": user_agent,
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://www.kfc.com.cn/kfccda/storelist/index.aspx",
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
        "Connection": "keep-alive",
        "X-Requested-With": "XMLHttpRequest"
    }
    
    try:
        logger.info(f"正在获取{province_name}的城市列表...")
        request = urllib.request.Request(url=url, headers=headers, data=data)
        response = urllib.request.urlopen(request)
        content = response.read().decode("utf-8")
        
        # 检查响应是否为空
        if not content.strip():
            logger.warning(f"获取省份ID {province_id} 的城市列表时返回了空响应")
            return {"Table1": []}
            
        return json.loads(content)
    except json.JSONDecodeError as e:
        logger.error(f"JSON解析错误: {e}")
        logger.error(f"原始响应内容: {content}")
        return {"Table1": []}
    except Exception as e:
        logger.error(f"获取城市列表时出错: {e}")
        return {"Table1": []}

def get_kfc_stores(city, province_name):
    """获取指定城市的KFC门店信息"""
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"
    url = "https://www.kfc.com.cn/kfccda/ashx/GetStoreList.ashx?op=cname"
    
    data = {
        "cname": city,
        "pid": "",
        "keyword": "",
        "pageIndex": "1",
        "pageSize": "100"  # 增加页面大小以获取更多数据
    }
    
    data = urllib.parse.urlencode(data).encode("utf-8")
    headers = {
        "User-Agent": user_agent,
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://www.kfc.com.cn/kfccda/storelist/index.aspx",
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
        "Connection": "keep-alive",
        "X-Requested-With": "XMLHttpRequest"
    }
    
    try:
        logger.info(f"正在获取{province_name}-{city}的KFC门店信息...")
        request = urllib.request.Request(url=url, headers=headers, data=data)
        response = urllib.request.urlopen(request)
        content = response.read().decode("utf-8")
        
        # 检查响应是否为空
        if not content.strip():
            logger.warning(f"获取城市 {city} 的门店信息时返回了空响应")
            return {"Table1": []}
            
        return json.loads(content)
    except json.JSONDecodeError as e:
        logger.error(f"JSON解析错误: {e}")
        logger.error(f"原始响应内容: {content}")
        return {"Table1": []}
    except Exception as e:
        logger.error(f"获取门店信息时出错: {e}")
        return {"Table1": []}

def save_stores_to_json(stores, city):
    """保存门店信息为JSON文件"""
    # 创建data目录（如果不存在）
    if not os.path.exists('data'):
        os.makedirs('data')
    
    # 保存为JSON文件
    file_path = f'data/kfc_{city}_stores.json'
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(stores, f, ensure_ascii=False, indent=4)
    
    logger.info(f"已将{city}的KFC门店信息保存到 {file_path} 文件中")
    
    # 打印门店数量
    if "Table1" in stores and stores["Table1"]:
        logger.info(f"{city}共有 {len(stores['Table1'])} 家KFC门店")
    else:
        logger.warning(f"{city}没有找到KFC门店信息")

def get_all_stores():
    """获取所有城市的KFC门店信息"""
    all_stores = {}
    
    # 获取所有省份
    provinces = get_all_cities()
    
    # 检查是否成功获取省份列表
    if not provinces.get("Table1"):
        logger.warning("无法获取省份列表，尝试使用预设的省份列表...")
        # 使用预设的省份列表
        provinces = {
            "Table1": [
                {"id": "1", "provinceName": "北京"},
                {"id": "2", "provinceName": "上海"},
                {"id": "3", "provinceName": "四川"},
                {"id": "4", "provinceName": "广东"},
                {"id": "5", "provinceName": "江苏"},
                {"id": "6", "provinceName": "浙江"}
            ]
        }
    
    # 使用tqdm创建省份进度条
    for province in tqdm(provinces.get("Table1", []), desc="处理省份", unit="省"):
        province_id = province.get("id")
        province_name = province.get("provinceName")
        
        # 获取该省份下的所有城市
        cities = get_cities_by_province(province_id, province_name)
        
        # 检查是否成功获取城市列表
        if not cities.get("Table1"):
            logger.warning(f"无法获取{province_name}的城市列表，尝试使用预设的城市列表...")
            # 使用预设的城市列表
            if province_name == "北京":
                cities = {"Table1": [{"cityName": "北京"}]}
            elif province_name == "上海":
                cities = {"Table1": [{"cityName": "上海"}]}
            elif province_name == "四川":
                cities = {"Table1": [{"cityName": "成都"}]}
            elif province_name == "广东":
                cities = {"Table1": [{"cityName": "广州"}, {"cityName": "深圳"}]}
            elif province_name == "江苏":
                cities = {"Table1": [{"cityName": "南京"}, {"cityName": "苏州"}]}
            elif province_name == "浙江":
                cities = {"Table1": [{"cityName": "杭州"}, {"cityName": "宁波"}]}
            else:
                cities = {"Table1": [{"cityName": province_name}]}
        
        # 使用tqdm创建城市进度条
        for city in tqdm(cities.get("Table1", []), desc=f"处理{province_name}的城市", unit="市", leave=False):
            city_name = city.get("cityName")
            
            try:
                # 获取该城市的门店信息
                stores = get_kfc_stores(city_name, province_name)
                
                # 保存到总数据中
                all_stores[f"{province_name}_{city_name}"] = stores
                
                # 保存单独的文件
                save_stores_to_json(stores, f"{province_name}_{city_name}")
                
                # 避免请求过于频繁
                time.sleep(1)
            except Exception as e:
                logger.error(f"获取{province_name}-{city_name}的门店信息时出错: {e}")
    
    # 创建data目录（如果不存在）
    if not os.path.exists('data'):
        os.makedirs('data')
    
    # 保存所有数据到一个文件
    file_path = 'data/kfc_all_stores.json'
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(all_stores, f, ensure_ascii=False, indent=4)
    
    logger.info(f"所有城市的KFC门店信息已保存到 {file_path} 文件中")
    return all_stores

if __name__ == "__main__":
    logger.info("KFC门店信息爬取程序启动")
    
    choice = input("请选择操作：\n1. 获取单个城市的门店信息\n2. 获取所有城市的门店信息\n请输入选项(1/2): ")
    
    if choice == "1":
        city = input("请输入要查询的城市名称：")
        try:
            stores = get_kfc_stores(city, "未知省份")
            save_stores_to_json(stores, city)
        except Exception as e:
            logger.error(f"获取数据时出错: {e}")
    elif choice == "2":
        logger.info("开始获取所有城市的KFC门店信息，这可能需要一些时间...")
        all_stores = get_all_stores()
        logger.info(f"共获取了 {len(all_stores)} 个城市的门店信息")
    else:
        logger.warning("无效的选项，请重新运行程序")
    
    logger.info("程序执行完毕")