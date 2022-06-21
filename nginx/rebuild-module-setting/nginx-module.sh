#! /bin/bash
apt update
apt upgrade -y
cd /usr/local/src
apt install wget git net-tools -y
wget http://nginx.org/download/nginx-1.18.0.tar.gz
tar -zxf nginx-1.18.0.tar.gz

apt-get install gcc make libxml2 libgd-dev libxml2-dev libxslt-dev uthash-dev geoip-database libgeoip-dev libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev -y 

wget https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/master.tar.gz
tar -xvzf master.tar.gz
git clone https://github.com/alibaba/tengine
cp /usr/local/src/tengine/modules/ngx_http_upstream_check_module/ /usr/local/src/ -r
git clone https://github.com/cubicdaiya/ngx_dynamic_upstream.git
mv nginx-goodies-nginx-sticky-module-ng-08a395c66e42/ nginx-sticky-module
git clone https://github.com/chobits/ngx_http_proxy_connect_module.git
cd nginx-sticky-module
sed -i '12i#include <openssl/sha.h>' ngx_http_sticky_misc.c
sed -i '13i#include <openssl/md5.h>' ngx_http_sticky_misc.c
cd ..
cd nginx-1.18.0
# 修正 ngx_http_proxy_connect_module
patch -p1 < /usr/local/src/ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1018.patch
./configure --prefix=/usr/local/nginx \
--with-compat --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module \
--with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_gunzip_module \
--with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_xslt_module=dynamic \
--with-stream=dynamic --with-stream_ssl_module --with-mail=dynamic --with-mail_ssl_module --add-module=/usr/local/src/nginx-sticky-module --add-module=/usr/local/src/ngx_dynamic_upstream --add-module=/usr/local/src/ngx_http_upstream_check_module --add-module=/usr/local/src/ngx_http_proxy_connect_module
make
make install
apt install nginx -y
cp /sbin/nginx /nginx.bak
service nginx stop
cp /usr/local/src/nginx-1.18.0/objs/nginx /sbin/
/usr/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
/sbin/nginx -s reload

cat>/usr/local/nginx/conf/nginx.conf<<EOF

#user  nobody;
user www-data;
worker_processes auto;
error_log /var/log/nginx/error.log;
worker_rlimit_nofile 735546;
pid        logs/nginx.pid;

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

	limit_req_status 403;
	limit_req_zone \$binary_remote_addr zone=one:10m rate=1r/s;
	limit_req_zone \$binary_remote_addr zone=wp:10m rate=5r/s;
	
	include       mime.types;
    default_type  application/octet-stream;
    add_header Strict-Transport-Security "max-age=63072000" always;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_buffer_size 4k;
	ssl_session_tickets off;
	ssl_session_timeout 10m;
	ssl_session_cache shared:SSL:50m;
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

	# include setting
    include /usr/local/nginx/conf/default.conf;
}

EOF

cat>/usr/local/nginx/conf/default.conf<<EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		try_files \$uri \$uri/ =404;
	}
}
EOF
/sbin/nginx -s reload