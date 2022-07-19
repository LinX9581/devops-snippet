#!/bin/bash
cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
After=network.service
Description=node_exporter

[Service]
ExecStart=/home/lin/exporter/node_exporter-1.3.1.linux-amd64/node_exporter
Type=simple

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart node_exporter.service
systemctl enable node_exporter.service


cat > /etc/systemd/system/process_exporter.service << EOF
[Unit]
After=network.service
Description=process_exporter

[Service]
ExecStart=/home/lin/exporter/process-exporter-0.7.5.linux-amd64/process-exporter -config.path=/home/lin/exporter/config.yml
Type=simple

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart process_exporter.service
systemctl enable process_exporter.service