# 停啟增減VM
start stop create delete
gcloud compute instances start php1 --zone asia-east1-b
# 連進開VM
gcloud compute ssh gcelab1 --zone asia-east1-c

# 查看特定清單
gcloud compute instances list