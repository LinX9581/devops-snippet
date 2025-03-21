# header 驗證方式
curl -I https://www.test.com
openssl s_client -connect www.test.com:443 -tls1_2

# 常用 header 設定
add_header X-Frame-Options "SAMEORIGIN";
add_header Content-Security-Policy "frame-ancestors 'self'";
add_header X-XSS-Protection "1; mode=block";
add_header X-Content-Type-Options "nosniff";
add_header Referrer-Policy "strict-origin";
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

set $cors_origin "";
if ($http_origin ~* ^https?://.*\.(domain\.com|domain1\.website)$) {
    set $cors_origin $http_origin;
}

if ($cors_origin) {
    add_header Access-Control-Allow-Origin $cors_origin always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
    add_header 'Access-Control-Allow-Credentials' 'true' always;
    add_header 'Access-Control-Allow-Headers' 'Origin, Content-Type, Accept' always;
}

# 常用 webserver 更改設定的方式
* gcp lb
gcloud compute backend-services update YOUR_BACKEND_SERVICE_NAME \
    --custom-request-header="X-My-Custom-Header: value"

* apache2
sudo nano /etc/apache2/apache2.conf
最下面新增
Header always set X-Content-Type-Options "nosniff"
sudo systemctl restart apache2

* nginx 
  add_header X-Content-Type-Options "nosniff";

# X-Frame-Options
* 阻止其他人 iframe 
add_header X-Frame-Options "SAMEORIGIN";

# Strict-Transport-Security
* 控制 HTTP 請求中的 Referrer 資訊，保護用戶隱私
add_header Referrer-Policy "strict-origin";

# X-XSS-Protection
* 啟用瀏覽器內建 XSS 功能
add_header X-XSS-Protection "1; mode=block";

# X-Content-Type-Options
* 避免讓惡意腳本被瀏覽器判斷成正常檔案型別 防止 MIME 類型嗅探攻擊
add_header X-Content-Type-Options "nosniff";

# Strict-Transport-Security
* 強制使用 HTTPS，防止中間人攻擊和 SSL 剝離攻擊。
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

# Content-Security-Policy
* 外部引用的靜態資源 只允許白名單網站
寬鬆版本
add_header Content-Security-Policy "default-src 'self' * data: blob:; script-src 'self' 'unsafe-inline' 'unsafe-eval' * data: blob:; style-src 'self' 'unsafe-inline' *; img-src 'self' * data: blob:; font-src 'self' * data:; frame-src 'self' *; frame-ancestors 'self'; upgrade-insecure-requests;" always;

嚴格版本
add_header Content-Security-Policy "default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self'; base-uri 'self'; form-action 'self'; frame-ancestors 'none'; block-all-mixed-content; upgrade-insecure-requests;" always;

平常使用版本
add_header X-Frame-Options "SAMEORIGIN";
add_header Content-Security-Policy "frame-ancestors 'self'";

# nginx cors
* 外部呼叫時 只允許白名單網站
* 寬鬆設置
add_header Access-Control-Allow-Origin *;
add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, PUT, DELETE, PATCH, HEAD, CONNECT' always;
add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';

* 限定特定域名訪問
set $cors_origin "";
if ($http_origin ~* ^https?://.*\.domain\.com$) {
	set $cors_origin $http_origin;
}
add_header Access-Control-Allow-Origin $cors_origin always;
add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
add_header 'Access-Control-Allow-Credentials' 'true' always;
add_header 'Access-Control-Allow-Headers' 'Origin, Content-Type, Accept' always;

要注意如果有 像是 nodejs express 要另外控制 cors
```
const corsOptions = {
  origin: function (origin, callback) {
    // 允許沒有 origin 的請求（比如直接訪問）
    if (!origin) return callback(null, true);
    const corsOptions = {
      origin: function (origin, callback) {
        // 允許沒有 origin 的請求（比如直接訪問）
        if (!origin) return callback(null, true);
        
        // 允許來自 test.com 和 linx.website 子域名的請求
        if (/^https?:\/\/.*\.(test\.com|linx\.website)$/.test(origin)) {
          callback(null, true);
        } else {
          callback(new Error('Not allowed by CORS'));
        }
      },
      credentials: true,
      methods: ['GET', 'POST', 'OPTIONS'],
      allowedHeaders: ['Origin', 'Content-Type', 'Accept']
    };
    
    // 對所有路徑應用這個 CORS 策略
    app.use(cors(corsOptions));
    // 允許來自 test.com 和 linx.website 子域名的請求
    if (/^https?:\/\/.*\.(test\.com|linx\.website)$/.test(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Origin', 'Content-Type', 'Accept']
};

// 對所有路徑應用這個 CORS 策略
app.use(cors(corsOptions));
```

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


# 解析真實IP deny ip , rate limit 預設是用 remote ip
real_ip_header X-Forwarded-For;
set_real_ip_from 130.211.0.0/22; // Private IP range for GCP Load Balancers
set_real_ip_from 35.191.0.0/16;  // Private IP range for GCP Load Balancers
real_ip_recursive on;

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