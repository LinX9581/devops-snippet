# 官方文件
https://cloud.google.com/sdk/gcloud/reference/compute/instances/add-tags

* 透過 IAM 帳號執行 cloud shell (如果key 已被從介面上移除，已授權的仍能運作會維持一小段時間後才會失效)
gcloud auth activate-service-account --key-file json
export GOOGLE_APPLICATION_CREDENTIALS=~/.sakey/now.json

* 設定預設專案&時區
gcloud config set project now-227907
gcloud config set compute/zone asia-east1-b

* 取得 vm列表
gcloud compute instances list
gcloud compute firewall-rules list
gcloud compute networks list

## stop browser ssh
* 已知的 private key 還是可以連，停止之後新加入的 key 就無法連線
sudo systemctl stop google-guest-agent

## get IAM
gcloud projects get-iam-policy [project] --format="json"

## gcloud allow api

## get current key 
gcloud auth list
gcloud auth revoke service-account-email@example.com

## get secret 
projects/[專案ID]/secrets/[secret名稱]/versions/1
gcloud secrets versions access 1 --secret="[secret名稱]" --project="[專案ID]"
export GOOGLE_CREDENTIALS=$(gcloud secrets versions access latest --secret="[secret名稱]" --project="[專案ID]")

## gcloud servce account
https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances#authenticate-with-service-account

* 取得目前VM的服務帳號
curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email" -H "Metadata-Flavor: Google"

* 取得預設服務帳號有哪些權限 (儘管它有編輯者權限 也會受限於 Oauth)
curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/scopes" -H "Metadata-Flavor: Google"

要改VM 的 scope 要停機
在 API and identity management 新增 Allow full access to all Cloud APIs
或開一個最低權限的IAM 給它

## 取得 Log
gcloud logging read 'logName="projects/prod-salses-vote/logs/cloudaudit.googleapis.com%2Factivity" AND 
protoPayload.authenticationInfo.principalEmail="itrd@gmail.com"' --format json --project prod-salses-vote