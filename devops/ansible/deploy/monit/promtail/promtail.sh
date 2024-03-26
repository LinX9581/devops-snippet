#!/bin/bash
gunzip -f /home/ansible/promtail/promtail-linux-amd64.gz
chmod a+x /home/ansible/promtail/promtail-linux-amd64
cat > /etc/systemd/system/promtail.service << EOF
[Unit]
After=network.target
Description=promtail

[Service]
ExecStart=/home/ansible/promtail/promtail-linux-amd64 -config.file=/home/ansible/promtail/promtail.yml
Type=simple

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable promtail.service
