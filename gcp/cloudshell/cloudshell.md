# 官方文件
https://cloud.google.com/sdk/gcloud/reference/compute/instances/add-tags

* 透過 IAM 帳號執行 cloud shell
gcloud auth activate-service-account --key-file json

* 設定預設專案&時區
gcloud config set project nownews-227907
gcloud config set compute/zone asia-east1-b

* 取得 vm列表
gcloud compute instances list

gcloud compute firewall-rules list

gcloud compute networks list