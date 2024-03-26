
# debian 安裝方式會不一樣
sudo apt update
sudo apt -y upgrade
sudo timedatectl set-timezone Asia/Taipei
sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common net-tools -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
systemctl enable docker.service

mkdir prometheus
cat>/prometheus/prometheus.yml<<EOF
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
- "/etc/prometheus/alertmanager/rules.yml"

alerting:
  alertmanagers:
    - static_configs:
      - targets:
        - 10.140.0.26:9093
  
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['10.140.0.26:9090']
  - job_name: 'host1'
    static_configs:
      - targets: ['10.140.0.26:9100']
EOF

cat>/prometheus/rules.yml<<EOF
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

cat>/prometheus/alertmanager.yml<<EOF
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


docker run --name alertmanager -d -p 9093:9093 -v /prometheus:/alertmanager \
prom/alertmanager --storage.path=/tmp --config.file=/alertmanager/alertmanager.yml

docker run -d -p 9090:9090 -v /prometheus:/etc/prometheus \
prom/prometheus --web.enable-lifecycle --config.file=/etc/prometheus/prometheus.yml

docker run -d -p 9100:9100 \
-v "/proc:/host/proc" \
-v "/sys:/host/sys" \
-v "/:/rootfs" \
--name=gra_node-exporter \
prom/node-exporter \
--path.procfs /host/proc \
--path.sysfs /host/sys \
--collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"