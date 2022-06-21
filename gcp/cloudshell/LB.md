# LB相關
#--------------------------------------------------------------------------------
# 查看所有後端服務 --globle
gcloud compute backend-services list
# 查看健康狀況
gcloud compute backend-services get-health java-lb --global
# import export
https://cloud.google.com/sdk/gcloud/reference/compute/backend-services/import
