#!/bin/bash
cat > /etc/systemd/system/kernel.service << EOF
[Unit]
After=network.service
Description=Log PPPoE ip

[Service]
ExecStart=sysctl -w net.ipv4.tcp_fin_timeout=15
ExecStart=sysctl -w net.ipv4.tcp_tw_reuse=1
ExecStart=sysctl -p
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart kernel.service
systemctl enable kernel.service