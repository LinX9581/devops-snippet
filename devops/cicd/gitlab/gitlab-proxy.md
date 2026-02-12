
# Gitlab Proxy
Gitlab 只允許特定IP連線

其餘機器只要能 SSH 到該機器並修改以下設定檔即可

~/.ssh/config

Host gitlab
    HostName gitlab
    User git
    ProxyCommand ssh ai@ip nc %h %p 2> /dev/null



* 允許 443

/etc/systemd/system/gitlab-tunnel.service
[Unit]
Description=SSH Tunnel to GitLab
After=network.target

[Service]
User=root
ExecStart=/usr/bin/ssh -N -L 443:gitlab.example.com:443 wl-gitlab-runner@ip -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target


systemctl daemon-reload
systemctl enable gitlab-tunnel.service
systemctl start gitlab-tunnel.service

echo "127.0.0.1 gitlab.gamania.com" >> /etc/hosts