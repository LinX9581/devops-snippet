官方文件
https://cloud.google.com/sdk/gcloud/reference/compute/instances/add-tags

部分VM 不允許下面動作
建立授權&專案&時區
gcloud auth login
gcloud config set project terra-test-353202
gcloud config set compute/zone asia-east1-c

需要建立 IAM帳戶
gcloud auth activate-service-account  --key-file json

test
gcloud compute instances list

