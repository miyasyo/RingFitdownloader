# -*- coding: utf-8 -*-
import os
import tweepy
import urllib
import ssl
import datetime

ssl._create_default_https_context = ssl._create_unverified_context
#= 画像の保存先ディレクトリ
IMAGES_DIR = ("./twitterimages/")
namedata = []
#= Twitter API Key の設定
CONSUMER_KEY ='nsZKP9Vw48dUo6Le7ID3vgeZS'
CONSUMER_SECRET = 'WZip8MHYbiqcmImNIVR5SsNjnJa6AVEzAju9OhRX7fkaun9uGG'
ACCESS_TOKEN_KEY = '4112067618-bjlJZec1y4OY7QTesLLrS4wIZ29EPEtItQv5O2Q'
ACCESS_TOKEN_SECRET = 'HfLGzAmWltQQai7f5vSyZxpnpyDA70BsgmzDxRBhDA0Mz'

class RingImageDownloader(object):
    def __init__(self):
        super(RingImageDownloader, self).__init__()
        self.set_twitter_api()
        self.media_url_list = []
    def run(self):
        self.download_url_list = []
        self.timelist = []
        self.imgcount = 0
        self.search()
        for url in self.download_url_list:
            for time in self.timelist:
                print(url)
                self.imgcount += 1
                self.download(url, time)

    def set_twitter_api(self):
        try:
            auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
            auth.set_access_token(ACCESS_TOKEN_KEY, ACCESS_TOKEN_SECRET)
            self.api = tweepy.API(auth)
        except Exception as e:
            print("[-] Error: ", e)
            self.api = None

    def search(self): #タイムラインから自分のツイートを検出後、特定のキーワードを絞り込み
        try:
            search_result = self.api.user_timeline(id='miyasyo0323',count=10)
            for result in search_result:
                if 'media' in result.entities:
                    if 'リングフィットアドベンチャー' in result.text:
                        for media in result.entities['media']:
                            url = media['media_url_https']
                            if url not in self.media_url_list:
                                self.media_url_list.append(url)
                                self.download_url_list.append(url)
                                self.timelist.append(result.created_at)
        except Exception as e:
            print("[-] Error: ", e)

    def download(self, url,time): #画像を保存する
        url_orig = '%s:orig' % url
        filename = url.split('/')[-1]
        litime = time
        print(litime.date())
        savepath = IMAGES_DIR + str(litime.date()) + 'data' + str(self.imgcount) +  '.jpg'
        print(savepath)
        namedata.append(savepath)
        try:
            response = urllib.request.urlopen(url_orig)
            print("success")
            with open(savepath, "wb") as f:
                f.write(response.read())
        except Exception as e:
            print("[-] Error: ", e)

def main():
    try:
        downloader = RingImageDownloader()
        downloader.run()
    except KeyboardInterrupt:
        pass

if __name__ == '__main__':
    main()