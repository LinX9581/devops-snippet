#! /bin/bash

mkdir /drone

DRONE_GITHUB_CLIENT_ID=ae3f121358113121b5a9
DRONE_GITHUB_CLIENT_SECRET=dbe19eb572cf69722acaec3f95d8e4a6e61dda96
DRONE_RPC_SECRET=Lonely-Kill-History-Bury-7 # = drone setting's screct name 
DRONE_SERVER_HOST=dronecicd.linx.website
DRONE_SERVER_PROTO=https
DRONE_RPC_SERVER=rpc.linx.website # 用不到
DRONE_RPC_PROTO=https

sudo apt update
sudo apt -y upgrade
sudo apt update

# stackdriver
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# nodejs
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt -y install nodejs
npm i nodemon pm2 yarn -g
sudo pm2 startup
apt install git -y

apt install nginx -y
sudo systemctl enable nginx
chown lin /etc/nginx/sites-enabled/default

# debian 安裝方式會不一樣
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
systemctl enable docker.service

cat>/etc/nginx/nginx.conf<<EOF
user www-data;
worker_processes auto;
error_log /var/log/nginx/error.log;
worker_rlimit_nofile 735546;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
	worker_connections 8192;
	multi_accept on;
}

http {

  	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	server_tokens off;
	reset_timedout_connection on;
	
	send_timeout 15;
	keepalive_timeout 15;
	
	client_body_buffer_size 128k;
	client_max_body_size 50m;
	client_body_timeout 15;
	client_header_timeout 15;
	
	open_file_cache_valid 3m;
	open_file_cache max=245182 inactive=5m;
	
	types_hash_max_size 2048;
	server_names_hash_max_size 2048;
	# server_name_in_redirect off;

	limit_req_status 403;
	limit_req_zone \$http_x_forwarded_for zone=one:10m rate=1r/s;
	limit_req_zone \$http_x_forwarded_for zone=wp:10m rate=5r/s;
	
	include /etc/nginx/mime.types;
	# include common/headers-http.conf;
	add_header Strict-Transport-Security "max-age=63072000" always;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_buffer_size 4k;
	ssl_session_tickets off;
	ssl_session_timeout 10m;
	ssl_session_cache shared:SSL:50m;
	#ssl_dhparam /etc/ssl/dhparam.pem;
	ssl_ecdh_curve prime256v1:secp384r1:secp521r1;
	ssl_prefer_server_ciphers on;
	ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256';
	
	##
	# Logging Settings
	##
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

	open_log_file_cache max=1000 inactive=30s valid=1m;

	##
	# Gzip Settings
	##

	gzip on;
	gzip_disable "msie6";

	gzip_vary on;
	gzip_proxied any;
	gzip_comp_level 6;
	gzip_buffers 16 8k;
	gzip_http_version 1.1;
	gzip_types application/atom+xml application/javascript application/json application/rss+xml application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/svg+xml image/x-icon text/css text/plain text/x-component text/xml text/javascript;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
	include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;

}

EOF

cat>/etc/nginx/sites-enabled/default<<EOF
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    ssl_certificate /etc/nginx/ssl/linx-website.crt;
    ssl_certificate_key /etc/nginx/ssl/linx-website.key;

    access_log /var/log/nginx/drone.linx.website_ssl-access.log main;
    error_log /var/log/nginx/drone.linx.website_ssl-error.log;

    server_name drone.linx.website;

	location / {
		proxy_pass http://127.0.0.1:4500;
		proxy_http_version 1.1;
		proxy_set_header Host $host;
	}
}
EOF

cat>/drone/docker-compose.yml<<EOF
version: '2'

services:
  drone-server:
    image: drone/drone:latest
    container_name: drone-server
    networks: 
      - dronenet        # 让drone-server和drone-agent处于一个网络中，方便进行RPC通信
    ports:
      - '4500:80'     # Web管理面板的入口 PROTO=https 时使用该端口
      - '4600:9000'    # RPC服务端口
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock   # docker.sock [1]
      - /var/data/drone/:/var/lib/drone             # drone数据存放路径
    environment:
      - DRONE_AGENTS_ENABLED=true                   # 使用Runner
      - DRONE_GITHUB_SERVER=https://github.com                    # github的地址
      - DRONE_GITHUB_CLIENT_ID=${DRONE_GITHUB_CLIENT_ID}          # 上一步获得的ClientID
      - DRONE_GITHUB_CLIENT_SECRET=${DRONE_GITHUB_CLIENT_SECRET}  # 上一步获得的ClientSecret
      - DRONE_RPC_SECRET=${DRONE_RPC_SECRET}                      
      - DRONE_SERVER_HOST=${DRONE_SERVER_HOST}                    # RPC域名(在一个实例上可以不用)
      - DRONE_SERVER_PROTO=${DRONE_SERVER_PROTO}                  # git webhook使用的协议(我建議http)
      - DRONE_OPEN=true                                           # 开发drone
      - DRONE_DATABASE_DATASOURCE=/var/lib/drone/drone.sqlite     # 数据库文件
      - DRONE_DATABASE_DRIVER=sqlite3                             # 数据库驱动，我这里选的sqlite
      - DRONE_DEBUG=true                                          # 測試相關，部署的时候建議先打开
      - DRONE_LOGS_DEBUG=true                                     # 測試相關，部署的时候建議先打开
      - DRONE_LOGS_TRACE=true                                     # 測試相關，部署的时候建議先打开
      - DRONE_USER_CREATE=username:TheWinds，admin:true           # 初始管理员用户
      - TZ=Asia/Shanghai                                          # 时区
    restart: always
  drone-agent:
    image: drone/agent:latest
    container_name: drone-agent
    networks: 
      - dronenet     # 让drone-server和drone-agent处于一个网络中，方便进行RPC通信
    depends_on:
      - drone-server 
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock # docker.sock [1]
    environment:
      - DRONE_RPC_SERVER=http://drone-server  # RPC服务地址
      - DRONE_RPC_SECRET=${DRONE_RPC_SECRET}  # RPC秘钥
      - DRONE_RPC_PROTO=${DRONE_RPC_PROTO}    # RPC协议(http || https)
      - DRONE_RUNNER_CAPACITY=2               # 最大并发执行的 pipeline 数
      - DRONE_DEBUG=true                      # 測試相關，部署的时候建議先打开
      - DRONE_LOGS_DEBUG=true                 # 測試相關，部署的时候建議先打开
      - DRONE_LOGS_TRACE=true                 # 測試相關，部署的时候建議先打开
      - TZ=Asia/Shanghai
    restart: always
networks:
  dronenet: 
EOF

cd /drone 
docker-compose up -d