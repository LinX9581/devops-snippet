## Stack Driver
[官方文件安裝參考](https://cloud.google.com/monitoring/agent/installation#agent-proxy-linux)
[linux 版本相容性](https://cloud.google.com/monitoring/agent/)

https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent/installation

stack driver
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

* 確認服務是否起來
sudo service google-fluentd status

* 砍掉
[ubuntu/centos]
sudo apt-get purge stackdriver-agnet
sudo service stackdriver-agent start

sudo yum remove stackdriver-agent

* 預警硬碟位置
硬碟可能在 /dev/root 和 /dev/sda1

# ref
# API
https://cloud.google.com/monitoring/docs/reference/libraries

alias gcurl='curl -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json"'

gcloud alpha services quota list --service=youtube.googleapis.com --consumer=projects/projectId
gcurl "https://serviceusage.googleapis.com/v1beta1/projects/pjid/services/youtube.googleapis.com/consumerQuotaMetrics"

serviceruntime.googleapis.com/quota/allocation/usage