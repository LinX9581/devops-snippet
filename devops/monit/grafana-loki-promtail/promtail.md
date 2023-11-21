wget https://github.com/grafana/loki/releases/download/v2.9.0/promtail-linux-amd64.zip

mv promtail-linux-amd64.zip /var/www

cd /tmp
mv promtail-linux-amd64.zip /tmp
unzip promtail-linux-amd64.zip

sudo mv promtail-linux-amd64 /usr/local/bin/promtail
sudo chmod a+x /usr/local/bin/promtail

[Unit]
Description=Promtail service

[Service]
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail/config.yml

[Install]
WantedBy=multi-user.target

sudo systemctl enable promtail
sudo systemctl start promtail
sudo systemctl status promtail
