## DMS
1. CDC 即時同步資料
會建立 replica 去同步 source database, 之後要把 DMS 的排程停掉 把 replica 變成獨立資料庫 (cloudSQL 介面上會有個 Promote replica)

Job 還沒開始 就已經會先建 replica 了
然後 source 和 目標 最好是同一個區域 台灣 a 區之類
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
ExecStart=/cloudsql-proxy/cloud_sql_proxy -instances=k88888888s-329606:asia-east1:prod-mysql-db=tcp:0.0.0.0:3307,
Restart=always
StandardOutput=file:/var/log/cloud_sql_proxy.log
StandardError=file:/var/log/cloud_sql_proxy_error.log

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start cloud_sql_proxy
sudo systemctl enable cloud_sql_proxy
sudo systemctl status cloud_sql_proxy

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

## 啟用 audit
用的是 GCP 自製的 cloudsql_mysql_audit 和 mysql 本身的 cloudsql_mysql_audit plugin 會有些不一樣

* 查看是否有啟用的三種方式
SHOW PLUGINS;
SHOW PROCEDURE STATUS WHERE Db = 'mysql' AND Name LIKE 'cloudsql%';
SELECT * FROM information_schema.plugins WHERE PLUGIN_NAME = 'cloudsql_mysql_audit';

* 新增規則
CALL mysql.cloudsql_create_audit_rule(
    'analytics_user@%',   -- user@host
    '*',         -- database
    '*',         -- table
    '*',         -- sql command
    'B',         -- op_result
    1,           -- reload_mode 1=reload 2=sequence
    @outval,
    @outmsg
);

* 參數
op_result should only be 'S'(successful), 'U'(unsuccessful), 'B'(both) or 'E' (exclude) 

* 查看規則
CALL mysql.cloudsql_list_audit_rule('*', @outval, @outmsg);

* 刪除規則
CALL mysql.cloudsql_delete_audit_rule('1,2',0,@outval,@outmsg);
SELECT @outval, @outmsg; -- 查看執行結果

規則id , reload_mode
0 for not reload the rule and 1 for reload.

* 讓 audit log 打到 logging
iam -> audit -> cloud sql 每個服務都有以下三個選項
只開 Admin Read 👉 只能監控誰查詢了 Cloud SQL 設定 (修改設定屬於 System Event 預設就有了)
只開 Data Read 👉 只能監控誰讀取了資料，但不記錄寫入行為 (特定用戶 Select Show mysqldump)
只開 Data Write 👉 只能監控誰改變了資料，但不記錄讀取行為 (特定用戶 Delete Update 等等)

要開 owner 才看的到 log