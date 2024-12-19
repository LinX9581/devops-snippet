
#! /bin/bash
export prometheusIP=172.16.2.4
export gcpProject=nownews-terraform
export webhookUrl=http:\/\/172.16.2.4:3005\/webhook

# install Docker
sudo apt update
sudo apt -y upgrade
sudo timedatectl set-timezone Asia/Taipei
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` test"
sudo apt update
sudo apt install docker-ce -y
sudo curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
systemctl enable docker.service

# install Prometheus
mkdir /devops/prometheus/alertmanager -p
mkdir /devops/prometheus-data -p
chmod 777 /devops/prometheus-data

cat>/devops/prometheus/prometheus.yml<<EOF
global:
  scrape_interval: 45s
  evaluation_interval: 45s

rule_files:
- "/etc/prometheus/alertmanager/rules.yml"

alerting:
  alertmanagers:
    - static_configs:
      - targets:
        - $prometheusIP:9093

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['$prometheusIP:9090']
      
  # - job_name: 'loki'
  #   static_configs:
  #     - targets: ['172.16.2.45:3100']

  # node_exporter   
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx_with_ip4]  # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - http://127.0.0.1       # prod

    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: $prometheusIP:9115  # The blackbox exporter's real hostname:port.

  # 使用 GCE SD 配置來發現位於台灣的所有 VM 監控 node_exporter
  - job_name: 'gce-$gcpProject-node'
    gce_sd_configs:
      - project: '$gcpProject'
        zone: 'asia-east1-b'  
        port: 9100
      - project: '$gcpProject'
        zone: 'asia-east1-a'  
        port: 9100
    relabel_configs:
      - source_labels: [__meta_gce_instance_status]
        regex: 'RUNNING'
        action: 'keep' 
      - source_labels: [__meta_gce_instance_name]
        target_label: instance

  # 使用 GCE SD 配置來發現位於台灣的所有 VM 監控 process_exporter
  - job_name: 'gce-$gcpProject-process'
    gce_sd_configs:
      - project: '$gcpProject'
        zone: 'asia-east1-b'  
        port: 9256
      - project: '$gcpProject'
        zone: 'asia-east1-a'  
        port: 9256
    relabel_configs:
      - source_labels: [__meta_gce_instance_status]
        regex: 'RUNNING'
        action: 'keep'
      - source_labels: [__meta_gce_instance_name]
        target_label: instance

EOF

docker run --name prometheus -d -p 9090:9090 \
  -v /devops/prometheus-data:/prometheus-data \
  -v /devops/prometheus:/etc/prometheus \
  prom/prometheus \
  --web.enable-lifecycle \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus-data \
  --storage.tsdb.retention.time=180d


# install alertmanager
cat>/devops/prometheus/alertmanager/rules.yml<<EOF
groups:
- name: AllInstances
  rules:
  - alert: InstanceDown
    # Condition for alerting
    expr: up == 0
    for: 1m
    # Annotation - additional informational labels to store more information
    annotations:
      title: 'Instance {{ \$labels.instance }} down'
      description: '{{ \$labels.instance }} of job {{ \$labels.job }} has been down for more than 1 minute.'
    # Labels - additional labels to be attached to the alert
    labels:
      severity: 'critical'
EOF

cat>/devops/prometheus/alertmanager/alert.yml<<EOF
global: 
  resolve_timeout: 5m
route:
  receiver: critical
  group_wait: 10s # 最初即第一次等待多久時間傳送一組警報的通知
  group_interval: 5m
  repeat_interval: 5m
  routes:
  - match:
      severity: critical
    receiver: critical
  - match:
      severity: down
    receiver: critical
  - match:
      severity: warning
    receiver: critical
  - match:
      severity: test
    receiver: test
receivers:
- name: 'critical'
  webhook_configs:
  - url: '$webhookUrl'
    send_resolved: true
- name: 'test'
  webhook_configs:
  - url: '$webhookUrl'
    send_resolved: true
EOF

docker run --name alertmanager -d -p 9093:9093 \
  -v /devops/prometheus/alertmanager:/alertmanager \
  prom/alertmanager \
  --storage.path=/tmp \
  --config.file=/alertmanager/alert.yml


# install blackbox_exporter
mkdir /devops/prometheus/exporter/blackbox_exporter -p
cat>/devops/prometheus/exporter/blackbox_exporter/blackbox.yml<<EOF
modules:
  http_2xx_with_ip4:
    prober: http
    timeout: 5s
    http:
      preferred_ip_protocol: "ip4"
EOF

docker run -d -p 9115:9115 --name blackbox-exporter -v /devops/prometheus/exporter/blackbox_exporter:/config prom/blackbox-exporter --config.file=/config/blackbox.yml

# install grafana
docker run --name=grafana1 -d -p 3000:3000 \
    grafana/grafana:10.4.4 