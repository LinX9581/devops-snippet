
#! /bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install ca-certificates apt-transport-https -y 
sudo apt upgrade -y
sudo timedatectl set-timezone Asia/Taipei
sudo apt install wget net-tools -y
# php for ubuntu
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
# sudo apt install php7.4 php7.4-fpm php7.4-cli php7.4-common php7.4-xmlrpc php7.4-opcache php7.4-mysql php7.4-gd php7.4-zip php7.4-xml php7.4-cli php7.4-dev php7.4-imap php7.4-soap php7.4-intl php7.4-curl php7.4-mbstring git nginx mysql-server -y
sudo apt install php8.0-fpm php8.0-common php8.0-mysql php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-gd php8.0-xml php8.0-cli php8.0-zip git nginx mysql-server -y
sudo systemctl start php8.0-fpm nginx mysql
sudo systemctl enable php8.0-fpm nginx mysql
cd /tmp
wget http://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz -C /var/www/
sudo chown www-data: /var/www/wordpress/ -R
cd /var/www/wordpress/
cp /home/ansible/env/config/wp-config.php /var/www/wordpress
chown ansible /var/www/wordpress/wp-config.php

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


cat>/etc/nginx/sites-enabled/default<<EOF
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    ssl_certificate /etc/nginx/ssl/linx-website.crt;
    ssl_certificate_key /etc/nginx/ssl/linx-website.key;

    server_name wordpress.linx.website;
    root /var/www/wordpress;
    index index.php index.html index.htm index.nginx-debian.html;

    access_log /var/log/nginx/wordpress.linx.website_ssl-access.log;
    error_log /var/log/nginx/wordpress.linx.website_ssl-error.log;


    location / {
        try_files \$uri \$uri/ /index.php?\$is_args\$args =404;
    }
 
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.0-fpm.sock;
    }
 
    location ~ /\.ht {
        deny all;
    }

    if (!-e \$request_filename) {
        rewrite ^.*$ /index.php last;
    }
}
EOF

cp /home/ansible/env/ssl /etc/nginx -R
chown ansible /etc/nginx/sites-enabled/default
service nginx restart