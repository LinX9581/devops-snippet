#! /bin/bash

# Update and install basic packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates apt-transport-https wget net-tools software-properties-common git nginx mysql-server

# Set timezone
sudo timedatectl set-timezone Asia/Taipei
sudo apt install wget net-tools -y
sudo chmod -x /etc/update-motd.d/*

# Add PHP repository for Ubuntu
if [ "$OS" = "ubuntu" ]; then
    sudo add-apt-repository ppa:ondrej/php -y
fi

# Install PHP based on the version specified
sudo apt update

if [ -n "$PHP" ]; then
    PHP_VERSION="$PHP"
fi

if [ "$PHP_VERSION" = "7.4" ]; then
    sudo apt install -y php7.4-fpm php7.4-common php7.4-mysql php7.4-curl php7.4-mbstring php7.4-xml php7.4-gd php7.4-zip php7.4-cli
    sudo systemctl enable php7.4-fpm
    sudo systemctl start php7.4-fpm
elif [ "$PHP_VERSION" = "8.0" ]; then
    sudo apt install -y php8.0-fpm php8.0-common php8.0-mysql php8.0-curl php8.0-mbstring php8.0-xml php8.0-gd php8.0-zip php8.0-cli
    sudo systemctl enable php8.0-fpm
    sudo systemctl start php8.0-fpm
elif [ "$PHP_VERSION" = "8.2" ]; then
    sudo apt install -y php8.2-fpm php8.2-common php8.2-mysql php8.2-curl php8.2-mbstring php8.2-xml php8.2-gd php8.2-zip php8.2-cli
    sudo systemctl enable php8.2-fpm
    sudo systemctl start php8.2-fpm
elif [ "$PHP_VERSION" = "8.3" ]; then
    sudo apt install -y php8.3-fpm php8.3-common php8.3-mysql php8.3-curl php8.3-mbstring php8.3-xml php8.3-gd php8.3-zip php8.3-cli
    sudo systemctl enable php8.3-fpm
    sudo systemctl start php8.3-fpm
elif [ "$PHP_VERSION" = "8.4" ]; then
    sudo apt install -y php8.4-fpm php8.4-common php8.4-mysql php8.4-curl php8.4-mbstring php8.4-xml php8.4-gd php8.4-zip php8.4-cli
    sudo systemctl enable php8.4-fpm
    sudo systemctl start php8.4-fpm
else
    echo "Error: PHP version $PHP_VERSION is not supported. Use 7.4, 8.0, 8.2, 8.3, 8.4"
    exit 1
fi

# Test PHP installation by creating a PHP info file
cat > /var/www/html/index.php <<EOF
<?php
phpinfo();
?>
EOF

# Configure nginx
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
    add_header Content-Security-Policy "frame-ancestors '*'";
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
    add_header Strict-Transport-Security "max-age=63072000" always;
    default_type application/octet-stream;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_buffer_size 4k;
    ssl_session_tickets off;
    ssl_session_timeout 10m;
    ssl_session_cache shared:SSL:50m;
    ssl_ecdh_curve prime256v1:secp384r1:secp521r1;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256';

    log_format main '\$remote_addr \$upstream_response_time \$upstream_cache_status [\$time_local] '
	                '\$http_host "\$request" \$status \$body_bytes_sent '
	                '"\$http_referer" "\$http_user_agent" "\$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;
    
    gzip on;
    gzip_disable "msie6";
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types application/atom+xml application/javascript application/json application/rss+xml application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/svg+xml image/x-icon text/css text/plain text/x-component text/xml text/javascript;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

# Configure the default site for nginx
cat > /etc/nginx/sites-enabled/default <<EOF
server {
    listen 80;
    listen [::]:80;
    root /var/www/html;
    index index.php index.html;
    
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    
    location / {
        try_files \$uri \$uri/ /index.php?\$is_args\$args;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
    }
    
    location ~ /\.ht {
        deny all;
    }
}
EOF

# Restart nginx to apply changes
sudo systemctl restart nginx

echo "Installation completed with PHP $PHP_VERSION on $OS"
