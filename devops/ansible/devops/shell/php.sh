
#! /bin/bash
# 預設系統是 ubuntu & php7.4
export os=ubuntu	# debian or ubuntu
export php=7.4		# 8.0 or all

sudo apt update
sudo apt upgrade -y
sudo apt install ca-certificates apt-transport-https -y 
sudo apt upgrade -y
sudo timedatectl set-timezone Asia/Taipei
sudo apt install wget net-tools -y

if [ $os = "debian" ]
then
	# php for debian
	wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
	echo deb https://packages.sury.org/php/ stretch main | sudo tee /etc/apt/sources.list.d/php.list
	sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'
else
	# php for ubuntu
	sudo apt install software-properties-common
	sudo add-apt-repository ppa:ondrej/php -y
fi

sudo apt update
sudo apt upgrade -y
sudo apt-get install ca-certificates apt-transport-https -y
apt install git nginx mariadb-server mariadb-client -y
sudo systemctl start nginx mariadb
sudo systemctl enable nginx mariadb
if [ $php = "8.0" ]
then
	sudo apt install php8.0-fpm php8.0-common php8.0-mysql php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-gd php8.0-xml php8.0-cli php8.0-zip -y
	sudo systemctl enable php8.0-fpm
	sudo systemctl start php8.0-fpm
elif [ $php = "all" ]
then
	sudo apt install php7.4 php7.4-fpm php7.4-cli php7.4-common php7.4-xmlrpc php7.4-opcache php7.4-mysql php7.4-gd php7.4-zip php7.4-xml php7.4-cli php7.4-dev php7.4-imap php7.4-soap php7.4-intl php7.4-curl php7.4-mbstring -y
	sudo apt install php8.0-fpm php8.0-common php8.0-mysql php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-gd php8.0-xml php8.0-cli php8.0-zip -y
	sudo systemctl start php8.0-fpm php7.4-fpm
	sudo systemctl enable php8.0-fpm php7.4-fpm
else 
	sudo apt install php7.4 php7.4-fpm php7.4-cli php7.4-common php7.4-xmlrpc php7.4-opcache php7.4-mysql php7.4-gd php7.4-zip php7.4-xml php7.4-cli php7.4-dev php7.4-imap php7.4-soap php7.4-intl php7.4-curl php7.4-mbstring -y
	sudo systemctl enable php7.4-fpm
	sudo systemctl start php7.4-fpm
fi

cat>/var/www/html/index.php<<EOF
<?php
phpinfo();
?>
EOF
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
  listen 80;
  listen [::]:80;
  #server_name example.com;
  root /var/www/html;
  index index.php index.html index.htm index.nginx-debian.html;

  access_log /var/log/nginx/access.log main;
  error_log /var/log/nginx/error.log;

  location / {
    try_files \$uri \$uri/ /index.php?\$is_args\$args =404;
  }

  location ~ ^/(doc|sql|setup)/ {
    deny all;
  }

  location ~ \.php\$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php7.4-fpm.sock;
  }

  location ~ /\.ht {
    deny all;
  }
}
EOF

if [ $php = "8.0" ]
then
	sed -i 's/7.4/8.0/g' /etc/nginx/sites-enabled/default
fi

service nginx restart