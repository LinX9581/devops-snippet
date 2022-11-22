# nginx req limit
server.conf
limit_req zone=uat;

nginx.conf
limit_req_status 403;
limit_req_zone $http_x_forwarded_for zone=uat:10m rate=5r/s;
limit_req zone=uat burst=5 nodelay; 

https://blog.csdn.net/hellow__world/article/details/78658041

# proxy to https
location / {
    proxy_pass https://$http_x_forwarded_to; 
    proxy_ssl_server_name on;
}
# nginx cors
add_header Access-Control-Allow-Origin *;
add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';

# nginx 防盜鏈
location ~* .*\.(gif|jpg|ico|png|css|svg|js|flv)$ {
	root /usr/local/nginx/static;
	valid_referers none blocked  *.gupao.com ; // 有效的来源
	if ($invalid_referer) { // 无效的来源的话就给404
		#rewrite ^/ http://www.youdomain.com/404.jpg;
		return 403;
		break;
	 }
	 access_log off;
}
复制
none
 “Referer” 来源头部为空的情况
 blocked
 “Referer”来源头部不为空，但是里面的值被代理或者防火墙删除了，这些值都不以http://或者https://开头.
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

# nginx 防護
https://github.com/loveshell/ngx_lua_waf
sudo apt install libnginx-mod-http-lua

# php-fpm
https://blog.gtwang.org/linux/nginx-fastcgi-cache-for-wordpress-tutorial/

# 解析真實IP deny ip , rate limit 預設是用
real_ip_header X-Forwarded-For;
set_real_ip_from 130.211.0.0/22; // Private IP range for GCP Load Balancers
set_real_ip_from 35.191.0.0/16;  // Private IP range for GCP Load Balancers
real_ip_recursive on;

# 開檔案上限
https://www.gushiciku.cn/pl/gOAI/zh-tw