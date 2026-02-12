
#! /bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install ca-certificates apt-transport-https -y 
sudo apt upgrade -y
sudo timedatectl set-timezone Asia/Taipei
sudo apt install wget net-tools -y
sudo chmod -x /etc/update-motd.d/*

# 安裝 MySQL Server
sudo apt install mysql-server -y
sudo systemctl enable mysql
sudo systemctl start mysql

# 配置 MySQL 資料庫和使用者
# 設定 MySQL root 密碼為空（預設），然後建立資料庫和使用者
sudo mysql -e "CREATE DATABASE IF NOT EXISTS wp_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'dev'@'localhost' IDENTIFIED BY '00000000';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wp_db.* TO 'dev'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# php for ubuntu
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install -y php8.4-fpm php8.4-common php8.4-mysql php8.4-curl php8.4-mbstring php8.4-xml php8.4-gd php8.4-zip php8.4-cli
sudo systemctl enable php8.4-fpm

# 配置 PHP 上傳大小設定
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 50M/' /etc/php/8.4/fpm/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 50M/' /etc/php/8.4/fpm/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = 256M/' /etc/php/8.4/fpm/php.ini
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /etc/php/8.4/fpm/php.ini
sudo sed -i 's/^max_input_time = .*/max_input_time = 300/' /etc/php/8.4/fpm/php.ini
sudo sed -i 's/^max_input_vars = .*/max_input_vars = 5000/' /etc/php/8.4/fpm/php.ini

# 配置 PHP-FPM 效能設定 (針對 2c6g，30-50 使用者)
sudo sed -i 's/^pm = .*/pm = dynamic/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.max_children = .*/pm.max_children = 60/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.start_servers = .*/pm.start_servers = 15/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.min_spare_servers = .*/pm.min_spare_servers = 10/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.max_spare_servers = .*/pm.max_spare_servers = 25/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^;pm.max_requests = .*/pm.max_requests = 500/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.max_requests = .*/pm.max_requests = 500/' /etc/php/8.4/fpm/pool.d/www.conf

# 設定 PHP-FPM 程序優先權和額外參數
sudo sed -i 's/^;pm.process_idle_timeout = .*/pm.process_idle_timeout = 10s/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.process_idle_timeout = .*/pm.process_idle_timeout = 10s/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^;request_terminate_timeout = .*/request_terminate_timeout = 300/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^request_terminate_timeout = .*/request_terminate_timeout = 300/' /etc/php/8.4/fpm/pool.d/www.conf

sudo systemctl start php8.4-fpm
cd /tmp
wget http://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz -C /var/www/
sudo chown www-data: /var/www/wordpress/ -R
cd /var/www/wordpress/
sudo cp /home/ansible/env/config/wp-config.php /var/www/wordpress
sudo chown ansible /var/www/wordpress/wp-config.php

# 建立 nginx 目錄
sudo mkdir -p /etc/nginx/sites-enabled
sudo mkdir -p /etc/nginx/conf.d

sudo tee /etc/nginx/nginx.conf > /dev/null <<EOF

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
	# server_name_in_redirect off;

	limit_req_status 403;
	limit_req_zone \$binary_remote_addr zone=one:10m rate=1r/s;
	limit_req_zone \$binary_remote_addr zone=wp:10m rate=5r/s;
	
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


sudo tee /etc/nginx/sites-enabled/default > /dev/null <<EOF
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    ssl_certificate /etc/nginx/ssl/linx-bar.crt;
    ssl_certificate_key /etc/nginx/ssl/linx-bar.key;

    server_name wp.linx.bar;
    root /var/www/wordpress;
    index index.php index.html index.htm index.nginx-debian.html;

    access_log /var/log/nginx/wp.linx.bar_ssl-access.log;
    error_log /var/log/nginx/wp.linx.bar_ssl-error.log;


    location / {
        try_files \$uri \$uri/ /index.php?\$is_args\$args =404;
    }
 
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
 
    location ~ /\.ht {
        deny all;
    }

    if (!-e \$request_filename) {
        rewrite ^.*$ /index.php last;
    }
}
EOF

sudo cp /home/ansible/env/ssl /etc/nginx -R
sudo chown ansible /etc/nginx/sites-enabled/default
sudo service nginx restart