#!/bin/bash

# 定義變數
GCS_BUCKET="nownews-terraform-gcs"
MOUNT_POINT="/gcs"

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update
sudo apt-get install gcsfuse -y

# 創建掛載點目錄
mkdir -p $MOUNT_POINT

cat>/etc/systemd/system/gcsfuse.service<<EOF
[Unit]
Description=Mount Google Cloud Storage bucket using gcsfuse
After=network-online.target
Wants=network-online.target

[Service]
Type=forking
ExecStart=/usr/bin/gcsfuse -o allow_other --implicit-dirs $GCS_BUCKET $MOUNT_POINT
ExecStop=/bin/fusermount -u $MOUNT_POINT
Restart=on-failure
RestartSec=10
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now gcsfuse.service
sudo systemctl restart gcsfuse.service
