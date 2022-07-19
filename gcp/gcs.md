## GCS
免費5G
超過照下面計算
https://cloud.google.com/storage/pricing/?hl=zh-TW

建立方式
WP 套件名稱 WP-Stateless

進入 storage -> browser -> create a bucket 選擇地區
建立完 選擇 permission -> 建立要授權的信箱 選擇storage admin

本機授權
gcloud auth login

* 官方文件
https://cloud.google.com/storage/docs/gsutil/commands/cp

-n // 防止覆蓋文件
-m // muitiple thread

ex. 
gsutil -m cp -r dir gs://my-bucket
gsutil cp -r /var/log/nginx/access.log.3.gz gs://nginx-access-log
gsutil cp -r gs://linxtest/access.log.2.gz /var/www
gsutil cp -r gs://wpbk gs://test
查看該bucket檔案
gsutil ls -a gs://bobee-1
查看該專案底下的值區
gsutil ls -p test-project

gsutil cp gs://sub-project/babyou gs://sub-project/old-babyou-image/
gsutil -m rm -r gs://my_bucket/subdir