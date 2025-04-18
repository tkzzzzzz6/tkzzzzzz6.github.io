#使用urllib获取百度源码
import urllib.request

# (1)定义一个url
url = "http://www.baidu.com"

# (2)模拟浏览器向服务器发送请求
response = urllib.request.urlopen(url)

# (3)获取响应中的页面的源码
response = urllib.request.urlopen(url)

print(response.read().decode("utf-8"))

# (4)获取响应中的页面的源码
# read() 返回的是字节形式的二进制数据
# 将二进制数据转换为字符串

# print(response.read().decode("utf-8"))

# print(response.status)

# print(response.headers)

# print(response.getcode())

# print(response.geturl())

# print(response.info())


