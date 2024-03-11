# cross-project-connect
## 建立步驟
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
多個資料庫就,隔開 key的方式讓跳板機直接吃service account 不要把key存vm
./cloud_sql_proxy -instances=k88888888s-329606:asia-east1:vpc2=tcp:0.0.0.0:3306 -credential_file=/k88888888s-329606-5b13666eef94.json &
./cloud_sql_proxy -instances=k88888888s-329606:asia-east1:vpc2=tcp:0.0.0.0:3307 &
* 如果只想讓local連就把 0.0.0.0: 拿掉，否則該台會變跳板機，其他台可以透過該台的IP連到該專案的cloud sql
* 該機器要開放外連 要開啟3306 & 白名單IP
* IAM key 權限需要 cloud sql client&Editor&Admin

## 建立參考
https://kejyuntw.gitbooks.io/google-cloud-platform-learning-notes/content/google-cloud-sql/proxy/google-cloud-sql-proxy-README.html

# cloudshell start stop sql
gcloud config set project projectID
gcloud sql instances patch sqlID --activation-policy=ALWAYS
gcloud sql instances patch sqlID --activation-policy=NEVER