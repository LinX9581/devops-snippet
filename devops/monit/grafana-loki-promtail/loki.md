
curl -O -L "https://github.com/grafana/loki/releases/download/v2.9.2/loki-linux-amd64.zip"
unzip "loki-linux-amd64.zip"
chmod a+x loki-linux-amd64
mv loki-linux-amd64 /devops/ansible-deploy-monitor/grafana-loki-promtail/

cat > /etc/systemd/system/loki.service << EOF
[Unit]
After=network.service
Description=loki

[Service]
ExecStart=/devops/ansible-deploy-monitor/grafana-loki-promtail/loki-linux-amd64 -config.file=/devops/ansible-deploy-monitor/grafana-loki-promtail/loki-config.yaml
Type=simple

[Install]
WantedBy=multi-user.target
EOF