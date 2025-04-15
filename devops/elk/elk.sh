#! /bin/bash

elk_password=elk_password

# ubuntu 安裝方式會不一樣
sudo apt update
sudo apt -y upgrade
sudo timedatectl set-timezone Asia/Taipei
apt install net-tools -y
if [ $os = "ubuntu" ]
then
    apt install docker.io -y
else
    sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt update
    apt-cache policy docker-ce
    sudo apt install docker-ce -y
fi
sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
systemctl enable docker.service

cd /var/www
git clone https://github.com/deviantony/docker-elk.git

cat>/var/www/elk/logstash/pipeline/logstash.conf<<EOF
input {
	beats {
		port => 5044
	}
}

filter {
	if ([log_topics] == "log_nginx_access") {
		grok {
			match => { "message" => ["%{IPORHOST:[nginx][access][remote_ip]} - %{DATA:[nginx][access][user_name]} \[%{HTTPDATE:[nginx][access][time]}\] \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\""] }
			remove_field => "message"
		}
		mutate {
			add_field => { "read_timestamp" => "%{@timestamp}" }
		}
		date {
			match => [ "[nginx][access][time]", "dd/MMM/YYYY:H:m:s Z" ]
			remove_field => "[nginx][access][time]"
		}
		useragent {
			source => "[nginx][access][agent]"
			target => "[nginx][access][user_agent]"
			remove_field => "[nginx][access][agent]"
		}
	}
	else if ([log_topics] == "log_nginx_access1") {
		grok {
			match => { "message" => ["%{IPORHOST:[nginx][access][remote_ip]} - %{DATA:[nginx][access][user_name]} \[%{HTTPDATE:[nginx][access][time]}\] \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\""] }
			remove_field => "message"
		}
		mutate {
			add_field => { "read_timestamp" => "%{@timestamp}" }
		}
		date {
			match => [ "[nginx][access][time]", "dd/MMM/YYYY:H:m:s Z" ]
			remove_field => "[nginx][access][time]"
		}
		useragent {
			source => "[nginx][access][agent]"
			target => "[nginx][access][user_agent]"
			remove_field => "[nginx][access][agent]"
		}
	}
}

output {
	if [log_topics] == "log_nginx_access" {
		elasticsearch {
			hosts => "elasticsearch:9200"
			user => "elastic"
			password => "$elk_password"
			index => "nginx-access-%{+xxxx.ww}"
		}
	}
	else if [log_topics] == "log_nginx_access1" {
		elasticsearch {
			hosts => "elasticsearch:9200"
			user => "elastic"
			password => "$elk_password"
			index => "nginx-access-1-%{+xxxx.ww}"
		}
	}
}
EOF

cat>/var/www/docker-elk/logstash/config/logstash.yml<<EOF
---
http.host: "0.0.0.0"
xpack.monitoring.elasticsearch.hosts: [ "http://elasticsearch:9200" ]

## X-Pack security credentials
#
xpack.monitoring.enabled: true
xpack.monitoring.elasticsearch.username: elastic
xpack.monitoring.elasticsearch.password: '$elk_password'

EOF

cat>/var/www/elk/elasticsearch/config/elasticsearch.yml<<EOF
---
cluster.name: "docker-cluster"
network.host: 0.0.0.0
xpack.license.self_generated.type: basic
xpack.security.enabled: true
xpack.monitoring.collection.enabled: true

EOF

cat>/etc/nginx/sites-enabled/default<<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    access_log /var/log/nginx/access.log main;
    server_name _; 

    location / {
        try_files \$uri \$uri/ =404;
    }
}

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

service nginx restart
cd /var/www/elk
docker-compose up -d