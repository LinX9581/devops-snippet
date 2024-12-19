## DMS
1. CDC 即時同步資料
會建立 replica 去同步 source database, 之後要把 DMS 的排程停掉 把 replica 變成獨立資料庫 (cloudSQL 介面上會有個 Promote replica)

2. one-time 

## 故障排除
allocaion ip ranges 被 release 會導致無法建立 cloudsql
可用 
gcloud services vpc-peerings list --network=[YOUR_VPC_NETWORK] --project=[YOUR_PROJECT_ID]
查看已建立的 allocation 然後重建

## cross-project-connect
### STEP
https://blog.cloud-ace.tw/database/cloud-sqlpart2-cloud-sql-proxy/
1. 先在IAM的服務帳戶建立帳戶
並建立金鑰

2. local 裝上
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy

3. 啟動 proxy 服務
要啟用 Cloud SQL Admin API
gcloud services enable sqladmin.googleapis.com

instances = cloudsql -> overview -> connection name
多個資料庫就,隔開
./cloud_sql_proxy -instances=k88888888s-329606:asia-east1:vpc2=tcp:0.0.0.0:3306 -credential_file=/k88888888s-329606-5b13666eef94.json &
./cloud_sql_proxy -instances=k88888888s-329606:asia-east1:vpc2=tcp:0.0.0.0:3307 &
* 如果只想讓local連就把 0.0.0.0: 拿掉，否則該台會變跳板機，其他台可以透過該台的IP連到該專案的cloud sql
* 該機器要開放外連 要開啟3306 & 白名單IP
* IAM key 權限需要 cloud sql client&Editor&Admin

### 開機自動執行

cat > /etc/systemd/system/cloud_sql_proxy.service << EOF
[Unit]
Description=Google Cloud SQL Proxy
After=network.target

[Service]
ExecStart=/cloudsql-proxy/cloud_sql_proxy -instances=k88888888s-329606:asia-east1:prod-mysql-db=tcp:0.0.0.0:3307,k88888888s-329606:asia-east1:prod-mysql-db-replica3-300g=tcp:0.0.0.0:3308,k88888888s-329606:asia-east1:prod-analytics-m-db=tcp:0.0.0.0:3306
Restart=always
StandardOutput=file:/var/log/cloud_sql_proxy.log
StandardError=file:/var/log/cloud_sql_proxy_error.log

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start cloud_sql_proxy
sudo systemctl enable cloud_sql_proxy

實際上 log 會存在
/var/log/cloud_sql_proxy_error.log

## 注意
ubuntu 22.04 可能會導致連線失敗
echo "PubkeyAcceptedKeyTypes=+ssh-rsa" >>/etc/ssh/sshd_config 
service sshd restart

## 建立參考
https://kejyuntw.gitbooks.io/google-cloud-platform-learning-notes/content/google-cloud-sql/proxy/google-cloud-sql-proxy-README.html

# cloudshell start stop sql
gcloud config set project projectID
gcloud sql instances patch sqlID --activation-policy=ALWAYS
gcloud sql instances patch sqlID --activation-policy=NEVER