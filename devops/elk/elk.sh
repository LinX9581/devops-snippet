#! /bin/bash

elk_password=elk_password

# ubuntu 安裝方式會不一樣
sudo apt update
sudo apt -y upgrade
sudo timedatectl set-timezone Asia/Taipei
apt install net-tools -y

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
systemctl enable docker.service

sudo mkdir /var/www -p
cd /var/www
git clone https://github.com/deviantony/docker-elk.git
cd /var/www/docker-elk

# 修正 logstash pipeline 配置（使用 elastic 與 ELASTIC_PASSWORD）
cat>logstash/pipeline/logstash.conf<<'EOF'
input {
	beats {
		port => 5044
	}
}

filter {
	if ([log_topics] == "www_log_nginx_access") {
		grok {
			match => { "message" => ["%{IPORHOST:[nginx][access][remote_ip]} %{DATA:[nginx][access][upstream_response_time]} %{DATA:[nginx][access][upstream_cache_status]} \[%{HTTPDATE:[nginx][access][time]}\] %{DATA:[nginx][access][http_host]} \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\""] }
			remove_field => "message"
		}
	}
	if ([log_topics] == "www2_log_nginx_access") {
		grok {
			match => { "message" => ["%{IPORHOST:[nginx][access][remote_ip]} %{DATA:[nginx][access][upstream_response_time]} %{DATA:[nginx][access][upstream_cache_status]} \[%{HTTPDATE:[nginx][access][time]}\] %{DATA:[nginx][access][http_host]} \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\""] }
			remove_field => "message"
		}
	}
	mutate {
		convert => {
			"[nginx][access][response_code]" => "integer"
			"[nginx][access][body_sent][bytes]" => "integer"
			"[nginx][access][http_version]" => "float"
		}
	}
	if [nginx][access][upstream_response_time] != "-" {
		mutate {
			convert => {
				"[nginx][access][upstream_response_time]" => "float"
			}
		}
	}
}

output {
	if [log_topics] == "www_log_nginx_access" {
		elasticsearch {
			hosts => "elasticsearch:9200"
			user => "elastic"
			password => "${ELASTIC_PASSWORD}"
			index => "www_nginx-access-%{+xxxx.ww}"
		}
	}
	else if [log_topics] == "www2_log_nginx_access" {
		elasticsearch {
			hosts => "elasticsearch:9200"
			user => "elastic"
			password => "${ELASTIC_PASSWORD}"
			index => "www_nginx-access-%{+xxxx.ww}"
		}
	}
}
EOF

# 創建環境配置文件
cat>.env<<EOF
ELASTIC_VERSION=9.1.4
ELASTIC_PASSWORD=$elk_password
LOGSTASH_INTERNAL_PASSWORD=$elk_password
KIBANA_SYSTEM_PASSWORD=$elk_password
EOF

# 官方預設是用 logstash_internal 但權限太低新增index還要改別的檔案 所以直接改用 elastic 並且另外建立密碼
cat>docker-compose.override.yml<<'EOF'
services:
  logstash:
    environment:
      ELASTIC_PASSWORD: ${ELASTIC_PASSWORD}
EOF

# 只啟動 Elasticsearch，等待就緒後再執行 setup
docker compose up -d elasticsearch

echo "等待 Elasticsearch 就緒..."
for i in $(seq 1 60); do
  code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9200 || true)
  if [ "$code" = "200" ] || [ "$code" = "401" ]; then
    break
  fi
  sleep 5
done

# 運行初始化設置（建立/重設內建使用者與密碼，包括 logstash_internal）
docker compose --profile=setup up --exit-code-from setup setup

# 啟動 Logstash 與 Kibana
docker compose up -d logstash kibana
