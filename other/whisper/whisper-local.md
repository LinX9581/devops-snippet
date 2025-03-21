
## Linux Version  
要確保IP是 ipv6 比較不會被鎖  
  
* GPU Driver Install  
```
apt update
sudo apt install -y nvidia-driver-550-server nvidia-dkms-550-server
nvidia-smi
```
  
* 別人開源的 Whipser ASR Restful API  
```
docker run -d --gpus all -p 9000:9000 -e ASR_MODEL=base onerahmet/openai-whisper-asr-webservice:latest-gpu
```
  
```
git clone https://github.com/LinX9581/nodejs-whisper
cd nodejs-whisper && yarn install
mkdir public/download -p
cat>.env<<EOF
db_host=172.16.200.6
db_user=docker
db_password=00000000
port=3005
YOUTUBE_COOKIES=
yarn start
```
  
## Youtube 有時會擋IP  
可以參考套件 看是要用 IP輪轉 還是設 Cookies，也有說如何取得 Youtube 已登入的 Cookies  
目前程式只有把 Cookies 的部分註解  
https://github.com/distubejs/ytdl-core  
  
* 直接建一台 Proxy server  
```
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
    echo "http_port [::]:3128" >> /etc/squid/squid.conf
    echo "acl all src 0.0.0.0/0" >> /etc/squid/squid.conf
    echo "http_access allow all" >> /etc/squid/squid.conf
    systemctl restart squid'

```

```
curl --proxy http://<EXTERNAL_IP>:3128 http://ipinfo.io
curl --proxy http://[ipv6]:3128 http://ipv6.google.com
```
有回傳 html 就代表成功  
防火牆要允許被 ipv6 訪問 才能 proxy 到 proxy-server  

* local 測試方式
```
sudo wget -O /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
yt-dlp --version
yt-dlp --get-title --skip-download --sleep-requests 2 --sleep-interval 10 https://www.youtube.com/shorts/peQYevLHVRU
yt-dlp --get-title --skip-download --proxy http://35.194.8.9:3128 --sleep-requests 2 --sleep-interval 10 https://www.youtube.com/shorts/peQYevLHVRU
```

* 如果發現不能爬 可以更新套件
yt-dlp -U


