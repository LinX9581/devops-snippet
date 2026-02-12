#!/bin/bash

# 更新套件資料庫並安裝所需套件
sudo apt update
sudo apt-get install -y build-essential libssl-dev net-tools nginx curl

# 設定時區
sudo timedatectl set-timezone Asia/Taipei
sudo apt install wget net-tools -y
sudo chmod -x /etc/update-motd.d/*

# 安裝 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# 設定 NVM 環境變數
export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads bash_completion

# 安裝 Node.js 版本 22 並設為預設
nvm install 22.18.0
nvm use 22.18.0
nvm alias default 22.18.0

# 安裝常用全域套件
npm i pm2 yarn nodemon -g

# 設定 Node.js 應用
cat << EOF > /var/www/html/app.js
const http = require('http');

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('nodejs\n');
});

server.listen(3005, '127.0.0.1', () => {
  console.log('Server running on http://127.0.0.1:3005/');
});
EOF

# 設定 Nginx 反向代理
cat << EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3005;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# 更新 Nginx 配置
cat > /etc/nginx/nginx.conf <<EOF
user www-data;
worker_processes auto;
error_log /var/log/nginx/error.log;
worker_rlimit_nofile 735546;
pid /run/nginx.pid;

events {
    worker_connections 8192;
    multi_accept on;
}

http {
    add_header X-Frame-Options "SAMEORIGIN";
    add_header Content-Security-Policy "frame-ancestors 'self'";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";
    add_header Referrer-Policy "strict-origin";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

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

    limit_req_status 403;
    limit_req_zone \$http_x_forwarded_for zone=one:10m rate=1r/s;
    limit_req_zone \$http_x_forwarded_for zone=wp:10m rate=5r/s;

    include /etc/nginx/mime.types;
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

# 重新啟動 Nginx
sudo systemctl restart nginx

# 使用 PM2 啟動 Node.js 應用
pm2 start /var/www/html/app.js --name "node-app"
