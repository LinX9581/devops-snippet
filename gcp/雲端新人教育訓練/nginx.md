* 安裝 Nginx
apt install nginx -y


* 預設的 Nginx 設定檔格式
server {
    # 讓服務走 80 port
    listen 80 default_server;
    listen [::]:80 default_server;

    # Nginx 預設採用的資料夾 (要換其他資料夾請從這邊改)
    root /var/www/html;

    # 預設採用的主要 html 檔名
    index index.html index.htm index.nginx-debian.html;

    # 訪問網站的 Log 存放位置
    access_log /var/log/nginx/access.log main;

    # 要設置的 domain 預設是無
    server_name _;

    # 訪問 IP 或 url 如果有檔案則訪問 沒有檔案則顯示 404
    location / {
	try_files $uri $uri/ =404;
    }
}

* 使用 nano 編輯 Nginx 預設設定檔
nano /etc/nginx/sites-enabled/default

* 改完設定檔 要重啟 Nginx
service nginx restart