
# IP 127.0.0.1 改成VM的內部IP

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

mkdir /devops/prometheus/alertmanager -p
mkdir /devops/prometheus-data -p
chmod 777 /devops/prometheus-data

cat>/devops/prometheus/prometheus.yml<<EOF
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
- "/etc/prometheus/alertmanager/rules.yml"

alerting:
  alertmanagers:
    - static_configs:
      - targets:
        - 127.0.0.1:9093
  
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9090']
  - job_name: 'host1'
    static_configs:
      - targets: ['127.0.0.1:9100']
EOF

cat>/devops/prometheus/alertManager/rules.yml<<EOF
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

cat>/devops/prometheus/alertManager/alertmanager.yml<<EOF
global: 
  resolve_timeout: 5m
route:
  receiver: critical
  group_interval: 5s
  repeat_interval: 1m
  routes:
  - match:
      severity: critical
    receiver: critical
receivers:
- name: 'critical'
  webhook_configs:
  - url: 'http://127.0.0.1:3500/alert'
    send_resolved: true
EOF


docker run --name alertmanager -d -p 9093:9093 -v /devops/prometheus/alertManager:/alertmanager \
prom/alertmanager --storage.path=/tmp --config.file=/alertmanager/alertmanager.yml

docker run --name prometheus -d -p 9090:9090 -v /devops/backupdata/prometheus:/prometheus-data -v /devops/prometheus:/etc/prometheus \
prom/prometheus --web.enable-lifecycle --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus-data

docker run -d -p 9100:9100 \
-v "/proc:/host/proc" \
-v "/sys:/host/sys" \
-v "/:/rootfs" \
--name=node-exporter \
prom/node-exporter \
--path.procfs /host/proc \
--path.sysfs /host/sys \
--collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"