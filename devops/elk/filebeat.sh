#! /bin/bash
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.12.0-amd64.deb
sudo dpkg -i filebeat-8.12.0-amd64.deb

NGINX_LOG_PATH=access.log
INDEX_NAME=log_nginx_access
LOGSTASH_IP=localhost

# INDEX_NAME 要和 Logstash 的設定檔 log_topics 匹配

cat>/etc/filebeat/filebeat.yml<<EOF
filebeat.inputs:
- type: log
  enabled: true
  backoff: "1s"             # 一秒掃一次
  tail_files: false         # 預設是false 會從log最後一行開始記錄
  paths:
    - /var/log/nginx/$NGINX_LOG_PATH
  exclude_files: ['\.gz$']
  fields:                   # 這邊設的變數可以從logstash的output中取得 [fields][log_topics]
    log_topics: $INDEX_NAME
  fields_under_root: true   # 這邊設置true output那邊就不用加[fields]

output.logstash:
  hosts: ["$LOGSTASH_IP:5044"]

# 當機的話 資訊會存在 var/lib/filebeat/registry
# 檔案太大的話 clean_inactive clean_removed

logging:
  level: info
  to_files: true
  files:
    path: /var/log/filebeat
    name: filebeat
    keepfiles: 7
    permissions: 0644
    rotateeverybytes: 10485760

EOF

cat>/etc/filebeat/modules.d/nginx.yml<<EOF
- module: nginx
  access:
    enabled: true
    var.paths: ["/var/log/nginx/$NGINX_LOG_PATH"]
  error:
    enabled: true
    var.paths: ["/var/log/nginx/error.log"]
  ingress_controller:
    enabled: false
EOF

filebeat modules enable nginx
sudo systemctl start filebeat
sudo systemctl enable filebeat