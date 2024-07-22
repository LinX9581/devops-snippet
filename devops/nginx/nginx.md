
## uninstall nginx
sudo systemctl stop apache2.service
sudo systemctl disable apache2.service
sudo apt-get --purge remove nginx -y
sudo apt-get autoremove -y
dpkg --get-selections|grep nginx
sudo apt-get --purge remove nginx
sudo apt-get --purge remove nginx-common -y
sudo apt-get --purge remove nginx-core -y

## 自己編譯的nginx
* 先找執行檔在哪
find / -name "nginx"
whereis nginx

sudo /etc/nginx/sbin/nginx    # 啟用 Nginx 
sudo /etc/nginx/sbin/nginx -s stop   
sudo /etc/nginx/sbin/nginx -s reload 


## 參數詳解
https://zhuanlan.zhihu.com/p/372610935

# nginx 設定檔產生器
https://www.digitalocean.com/community/tools/nginx?domains.0.php.php=false&domains.0.reverseProxy.reverseProxy=true&domains.0.routing.root=false&global.app.lang=zhTW

# Geoip
https://github.com/wp-statistics/GeoLite2-City
# 中文設定文檔
https://magiclen.org/ubuntu-server-nginx/

# 參數優化
 https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-configuration

# nginx apache 比較
https://por.tw/Website_Design/%E7%B6%B2%E9%A0%81-http-%E4%BC%BA%E6%9C%8D%E5%99%A8-apache-%E8%88%87-nginx-%E7%9A%84%E5%84%AA%E7%BC%BA%E9%BB%9E%E6%AF%94%E8%BC%83%EF%BC%88%E7%B6%B2%E7%AB%99%E6%9E%B6%E8%A8%AD%E6%95%99%E5%AD%B8/

# rate limit 詳細介紹
https://blog.csdn.net/hellow__world/article/details/78658041

# 原理介紹
https://www.upyun.com/tech/article/378/%E6%88%91%E7%9C%BC%E4%B8%AD%E7%9A%84%20Nginx%EF%BC%88%E4%B8%80%EF%BC%89%EF%BC%9ANginx%20%E5%92%8C%E4%BD%8D%E8%BF%90%E7%AE%97.html

# TCP LB
https://iter01.com/68023.html

server {
	listen 80 default_server;
	listen [::]:80 default_server;

	server_name _;

	location / {
		proxy_pass http://backend;
		proxy_http_version 1.1;
		proxy_set_header Host $host;
	}
    ## 必須裝健康模組
	location = /status {
		check_status;
	}
    ## 必須裝動態更新模組
	location /dynamic {
        dynamic_upstream;
    }
}

upstream backend {
	sticky expires=1h;
	zone zone_for_backends 1m;
	#VM1
	server 34.81.41.232:3100;
	#VM2
	server 35.234.52.29:3100;
}


# nginx 防護
https://github.com/loveshell/ngx_lua_waf
sudo apt install libnginx-mod-http-lua

# php-fpm
https://blog.gtwang.org/linux/nginx-fastcgi-cache-for-wordpress-tutorial/


# 開檔案上限
https://www.gushiciku.cn/pl/gOAI/zh-tw