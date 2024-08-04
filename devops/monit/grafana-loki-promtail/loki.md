
cd /tmp
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

systemctl daemon-reload
systemctl enable loki.service
systemctl start loki
systemctl status loki



* 要確定 loki 裡面有資料 grafana 才能連到

* 預設資料只保存 15天
yaml 要新增
limits_config:
  retention_period: 2160h

* loki cluster
https://medium.com/lonto-digital-services-integrator/grafana-loki-configuration-nuances-2e9b94da4ac1

* 優化 loki
https://ganhua.wang/loki-ruler
https://github.com/tedmax100/OpenTelemetryEntryBeook/blob/main/ch10/loki_ruler/loki_ruler.md