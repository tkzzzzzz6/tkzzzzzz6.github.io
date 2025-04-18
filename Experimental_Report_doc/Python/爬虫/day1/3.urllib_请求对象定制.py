import urllib.request

url = "https://www.baidu.com/s?wd=%E9%99%88%E4%B8%BD%E5%90%9B"

user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"

headers = {
    "User-Agent": user_agent
}


request = urllib.request.Request(url=url, headers=headers)

response = urllib.request.urlopen(request)

content = response.read().decode("utf-8")

print(content)




