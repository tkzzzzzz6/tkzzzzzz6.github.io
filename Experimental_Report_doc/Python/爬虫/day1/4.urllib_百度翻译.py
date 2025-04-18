import urllib.request
import urllib.parse
import json

url = "https://fanyi.baidu.com/sug"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"
}

data = {
    "kw": "spider"
}

data = urllib.parse.urlencode(data).encode("utf-8")

request = urllib.request.Request(url=url, headers=headers, data=data)

response = urllib.request.urlopen(request)

content = response.read().decode("utf-8")

obj = json.loads(content)

print(obj)




