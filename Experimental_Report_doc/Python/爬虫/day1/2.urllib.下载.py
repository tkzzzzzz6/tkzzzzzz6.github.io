import urllib.request
#1.下载网页
# url_page = "http://www.baidu.com"
#在python中，url代表的是下载地址，filename文件的名字
# urllib.request.urlretrieve(url_page,"./temp/1.baidu.html')
# 2.下载图片
# url_img ='https://ww4.sinaimg.cn/mw690/008BY4DGly1i0gg1ukut7j31p62m7b29.jpg'
# urllib.request.urlretrieve(ur]_img,"./temp/2chen.jpg")
# 3.下载视频
url_video = 'http://t.cn/A6rFJejQ'
urllib.request.urlretrieve(url_video, './temp/3chen.mp4')