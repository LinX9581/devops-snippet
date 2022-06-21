# tags相關
#--------------------------------------------------------------------------------
# 查看所有標記
gcloud compute instances list --format="table(name,status,tags.list())"
# 查看特定標記
gcloud compute instances list --filter='tags:nodejs'
# 新增標記
gcloud compute instances add-tags ha11 --tags=tag-3 --zone=asia-east1-b
remove-tags
