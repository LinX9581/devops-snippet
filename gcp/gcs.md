## gcs 指令
* gcs 指令用法文件
https://cloud.google.com/storage/docs/gsutil/commands/cp
https://alexisperrier.com/gcp/2018/01/01/google-storage-gsutil.html

-n // 防止覆蓋文件
-m // muitiple thread

gcloud config set project [project_id]

* 讓特定IAM帳戶只有寫入權限
gcloud projects add-iam-policy-binding [PROJECT_ID] --member="serviceAccount:[SERVICE_ACCOUNT_EMAIL]" --role="roles/storage.objectCreator"

* create static web
gcloud storage buckets create gs://nn-gcs-test
gsutil cp -r /devops/gcs/index.html gs://nn-gcs-test
gsutil acl ch -u AllUsers:R gs://nn-gcs-test/index.html
https://storage.googleapis.com/nn-gcs-test/index.html

* create remove view
gsutil ls -p test-project 
gsutil -m cp -r dir gs://my-bucket
gsutil cp -r /var/log/nginx/access.log.3.gz gs://nginx-access-log
gsutil cp -r gs://linxtest/access.log.2.gz /var/www
gsutil cp -r gs://wpbk gs://test
gsutil ls -a gs://bobee-1
gsutil cp gs://sub-project/babyou gs://sub-project/old-babyou-image/
gsutil -m rm -r gs://my_bucket/subdir

* 讓特定資料夾公開&設定cache 但每次新增檔案 都要重新下指令
gsutil -m acl set -R -a public-read gs://sub-project/vote2022/
gsutil setmeta -h "Cache-Control:no-cache" gs://sub-project/vote2022/*

* gcp lb -> gcs
建立 http classic
gcs 要開放所有權限
Permissions -> GRANT ACCESS -> add allUsers




## GCS
## 費用
免費5G
超過照下面計算
https://cloud.google.com/storage/pricing/?hl=zh-TW


四個儲存方式 差別在越便宜的 取出費用越貴
費用分成A級和B級 如果經常需要從VM讀取 或複製資料都屬於A級操作 會有額外費用
* Standard Storage A級0.005/1000次
* Nearline Storage A級0.01/1000次
* Coldline Storage A級0.02/1000次
* Archive Storage A級0.05/1000次

如果變更物件類型
從1變到2
會收取 1的所有物件 * 2的A級操作費

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