## GCS
## 費用
免費5G
超過照下面計算
https://cloud.google.com/storage/pricing/?hl=zh-TW

## 授權方式
* WP 套件名稱 WP-Stateless使用方式同下
進入 storage -> browser -> create a bucket 選擇地區
建立完 選擇 permission -> 建立要授權的信箱 選擇storage admin

本機授權
gcloud auth activate-service-account --key-file json

## gcs mount to local
https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/installing.md

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update
sudo apt-get install gcsfuse
gcsfuse --key-file [key] --only-dir [dir] [bocket] [destination]
gcsfuse --key-file /key.json --only-dir vote2022 sub-project /mnt/gcs
umount /mnt/gcs
## gcs 指令
* gcs 指令用法文件
https://cloud.google.com/storage/docs/gsutil/commands/cp
https://alexisperrier.com/gcp/2018/01/01/google-storage-gsutil.html

-n // 防止覆蓋文件
-m // muitiple thread

ex. 
* 新增 移除 檢視
gsutil -m cp -r dir gs://my-bucket
gsutil cp -r /var/log/nginx/access.log.3.gz gs://nginx-access-log
gsutil cp -r gs://linxtest/access.log.2.gz /var/www
gsutil cp -r gs://wpbk gs://test
gsutil ls -a gs://bobee-1
gsutil cp gs://sub-project/babyou gs://sub-project/old-babyou-image/
gsutil -m rm -r gs://my_bucket/subdir
* 檢視該專案bucket
gsutil ls -p test-project 

* 讓特定資料夾公開&設定cache 但每次新增檔案 都要重新下指令
gsutil -m acl set -R -a public-read gs://sub-project/vote2022/
gsutil setmeta -h "Cache-Control:no-cache" gs://sub-project/vote2022/*

* gcp lb -> gcs
建立 http classic
gcs 要開放所有權限
Permissions -> GRANT ACCESS -> add allUsers