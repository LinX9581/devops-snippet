## gcs 常用指令

gcloud config set project [project_id]

-n // 防止覆蓋文件
-m // muitiple thread

gsutil ls -p test-project 
gsutil -m cp -r dir gs://my-bucket
gsutil cp -r /gcs/test.txt gs://nn-gcs-test
gsutil cp -r gs://nn-gcs-test/access.log.2.gz /var/www
gsutil cp -r gs://wpbk gs://test
gsutil ls -a gs://bobee-1
gsutil cp gs://sub-project/babyou gs://sub-project/old-babyou-image/
gsutil -m rm -r gs://my_bucket/subdir

* gcs 指令用法文件
https://cloud.google.com/storage/docs/gsutil/commands/cp
https://alexisperrier.com/gcp/2018/01/01/google-storage-gsutil.html

* 讓特定IAM帳戶只有寫入權限
gcloud projects add-iam-policy-binding [PROJECT_ID] --member="serviceAccount:[SERVICE_ACCOUNT_EMAIL]" --role="roles/storage.objectCreator"

### create static web
gcloud storage buckets create gs://nn-gcs-test
gsutil cp -r /devops/gcs/index.html gs://nn-gcs-test
gsutil acl ch -u AllUsers:R gs://nn-gcs-test/index.html
https://storage.googleapis.com/nn-gcs-test/index.html

### create gcp lb -> gcs -> website
* create bucket
gcloud storage buckets create gs://nn-gcs-test

* 檔案傳輸相關指令
rsync -avh --progress  ansible@10.140.15.213:/var/www/website /var/www/
gsutil cp -r /var/www/website gs://nn-gcs-test

* 讓資料夾有讀取權限
gsutil iam ch allUsers:objectViewer gs://nn-gcs-test

* 設定主頁面
gsutil web set -m index.html -e 404.html gs://nn-gcs-test
這個沒設的話 會變 GCS 目錄XML結構 而非 index.html

* 建立 backend-buckets 讓後端綁定
gcloud compute backend-buckets create eclipse-backend-bucket \
  --gcs-bucket-name nn-gcs-test

* 建立 lb 綁定 backend-buckets
gcloud compute url-maps create eclipse-url-map \
  --default-backend-bucket eclipse-backend-bucket

* create http proxy
gcloud compute target-http-proxies create eclipse-http-proxy \
  --url-map=eclipse-url-map

* create ip forwarding-rules
gcloud compute forwarding-rules create eclipse-http-rule \
  --global \
  --target-http-proxy=eclipse-http-proxy \
  --ports=80

* 讓特定資料夾公開&設定cache 但每次新增檔案 都要重新下指令
gsutil -m acl set -R -a public-read gs://sub-project/vote2022/
gsutil setmeta -h "Cache-Control:no-cache" gs://sub-project/vote2022/*

## price
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