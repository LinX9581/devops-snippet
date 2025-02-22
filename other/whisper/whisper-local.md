
apt update

sudo apt install -y nvidia-driver-550-server nvidia-dkms-550-server

nvidia-smi



## Youtube 有時會擋IP

* 直接建一台 Proxy server
gcloud compute instances create proxy-server \
  --machine-type=e2-micro \
  --zone=asia-east1-b \
  --network=media-tools-vpc \
  --subnet=media-tools-subvpc \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB \
  --metadata=startup-script='#!/bin/bash
    apt update && apt install -y squid
    echo "http_port 3128" > /etc/squid/squid.conf
    echo "acl all src 0.0.0.0/0" >> /etc/squid/squid.conf
    echo "http_access allow all" >> /etc/squid/squid.conf
    systemctl restart squid'

curl --proxy http://<EXTERNAL_IP>:3128 http://ipinfo.io