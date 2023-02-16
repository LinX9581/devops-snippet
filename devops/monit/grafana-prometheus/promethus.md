## 先在該目錄建立 /prometheus/prometheus.yml 寫入設定檔
docker run --name prometheus -d -p 9090:9090 -v /devops/prometheus:/etc/prometheus \
prom/prometheus --web.enable-lifecycle --config.file=/etc/prometheus/prometheus.yml


```

global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    monitor: 'edc-lab-monitor'

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

rule_files:
  # - "first.rules"
  # - "second.rules"
  
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['10.140.0.10:3007']
  
  - job_name: 'host'
    static_configs:
      - targets: ['10.140.0.10:9100','10.140.0.2:9100']

  - job_name: 'container'
    static_configs:
      - targets: ['10.140.0.10:3006','10.140.0.2:8080']
```

## local install prometheus
https://linoxide.com/how-to-install-prometheus-on-ubuntu/

sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.35.0/prometheus-2.35.0.linux-amd64.tar.gz
tar xvfz prometheus-2.35.0.linux-amd64.tar.gz
rm -rf prometheus-2.35.0.linux-amd64.tar.gz
cd prometheus-2.35.0.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
sudo chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

cat>/etc/systemd/system/prometheus.service<<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Restart=always
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file=/etc/prometheus/prometheus.yml \\
    --storage.tsdb.path=/var/lib/prometheus/ \\
    --web.console.templates=/etc/prometheus/consoles \\
    --web.console.libraries=/etc/prometheus/console_libraries \\
    --web.listen-address=0.0.0.0:9090 \\
    --web.enable-lifecycle \\
    --web.enable-admin-api

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
service prometheus restart

## gce pending -> 改用ansible大量裝agent services
* 官方
https://prometheus.io/docs/prometheus/latest/configuration/configuration/#gce_sd_config
https://github.com/cloudalchemy/ansible-prometheus/issues/153
* gce tag filter
https://github.com/prometheus/prometheus/issues/8233

https://blog.beck-yeh.idv.tw/linux/monitor/prometheus-grafana/prometheus-install/
https://github.com/DazWilkin/gcp-exporter