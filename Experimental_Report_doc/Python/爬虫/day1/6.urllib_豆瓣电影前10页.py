import urllib.request
import urllib.parse
import json


def create_request(page):
    base_url = "https://movie.douban.com/top250?start="
    data = {
        "start": (page - 1) * 20,
        "limit": 20
    }
    data = urllib.parse.urlencode(data)  # Remove .encode("utf-8")
    url = base_url + data
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"
    }
    return urllib.request.Request(url=url, headers=headers)

def get_content(request):
    response = urllib.request.urlopen(request)
    content = response.read().decode("utf-8")
    return content

def download_content(content, page):
    with open('./temp/douban_'+str(page)+'.json', 'w', encoding='utf-8') as fp:
        fp.write(content)

if __name__ == "__main__":
    start_page = int(input("请输入起始页码："))
    end_page = int(input("请输入结束页码："))

    for page in range(start_page, end_page + 1):
        request = create_request(page)
        content = get_content(request)
        download_content(content, page)
