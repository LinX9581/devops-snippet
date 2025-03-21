Google Cloud Storage (GCS)
當前日期：2025年3月3日
常用指令
設置項目
    gcloud config set project [project_id]
檔案操作
    gcloud auth activate-service-account --key-file="C:\youtube.json"

# 列出 bucket 內容
gsutil ls -p test-project 
gsutil ls -l gs://youtube

# 複製檔案/目錄到 GCS
gsutil -m cp -r dir gs://my-bucket
gsutil cp -r /gcs/test.txt gs://nn-gcs-test

# 從 GCS 下載檔案
gsutil cp -r gs://nn-gcs-test/access.log.2.gz /var/www

# 在 GCS 內複製
gsutil cp -r gs://wpbk gs://test

# 刪除 GCS 內的檔案/目錄
gsutil -m rm -r gs://my_bucket/subdir

IAM 權限設置
    # 設置特定 IAM 帳戶只有寫入權限
    gcloud projects add-iam-policy-binding [PROJECT_ID] --member="serviceAccount:[SERVICE_ACCOUNT_EMAIL]" --role="roles/storage.objectCreator"

# 設置特定 service account 只能讀取特定 bucket
gsutil iam ch serviceAccount:[SERVICE_ACCOUNT_EMAIL]:objectViewer gs://[BUCKET_NAME]

更多指令用法請參考：
    - gsutil cp 命令文檔：https://cloud.google.com/storage/docs/gsutil/commands/cp
    - Google Storage gsutil 指南：https://alexisperrier.com/gcp/2018/01/01/google-storage-gsutil.html
防護機制
Soft delete policy
 預設開啟，保存被刪除的物件 7 天。只保存物件，不保存 Bucket。
檢視被刪除的物件
 gsutil ls -r gs://your-bucket-name
復原被刪除的物件
 gsutil mv gs://your-bucket-name/path/to/deleted/object gs://your-bucket-name/path/to/restored/object

Object versioning
 可以選擇保留版本數量、保存天數等。同樣只儲存物件，不保存 Bucket。
開啟 Versioning
 gcloud storage buckets update gs://nn-gcs-test3 --versioning
設置生命週期規則
 gcloud storage buckets update gs://nn-gcs-test3 --lifecycle-file=life.json
 life.json 範例：
 {
   "rule": [
     {
       "action": {"type": "Delete"},
       "condition": {
         "isLive": false,
         "numNewerVersions": 1,
         "age": 1
       }
     }
   ]
 }
檢視所有版本的物件
 gcloud storage ls -a gs://nn-gcs-test3/test-site
復原特定版本
 gcloud storage cp gs://$BUCKET_NAME#1705652345128673 gs://$BUCKET_NAME/

建立靜態網站
直接使用 GCS 託管
    # 創建 bucket
    gcloud storage buckets create gs://nn-gcs-test

# 上傳檔案
gsutil cp -r /devops/gcs/index.html gs://nn-gcs-test

# 設置公開讀取權限
gsutil acl ch -u AllUsers:R gs://nn-gcs-test/index.html

# 訪問網站
https://storage.googleapis.com/nn-gcs-test/index.html

使用 GCP 負載平衡器指向 GCS
    1. 創建 bucket 並上傳檔案
        gcloud storage buckets create gs://nn-gcs-test
        gsutil cp -r /var/www/website gs://nn-gcs-test

2. 設置權限和主頁面
    gsutil iam ch allUsers:objectViewer gs://nn-gcs-test
    gsutil web set -m index.html -e 404.html gs://nn-gcs-test

3. 創建後端 bucket
    gcloud compute backend-buckets create eclipse-backend-bucket --gcs-bucket-name nn-gcs-test

4. 創建 URL 映射
    gcloud compute url-maps create eclipse-url-map --default-backend-bucket eclipse-backend-bucket

5. 創建 HTTP 代理
    gcloud compute target-http-proxies create eclipse-http-proxy --url-map=eclipse-url-map

6. 創建轉發規則
    gcloud compute forwarding-rules create eclipse-http-rule --global --target-http-proxy=eclipse-http-proxy --ports=80

價格
    GCS 提供免費 5GB 存儲空間。超過部分按以下方式計費：
    - 四種儲存類型：Standard, Nearline, Coldline, Archive
    - 費用分為 A 級和 B 級操作
    - 詳細定價請參考 GCS 定價頁面：https://cloud.google.com/storage/pricing/?hl=zh-TW
將 GCS 掛載到本地
    使用 gcsfuse 工具可以將 GCS bucket 掛載到本地文件系統。
安裝 gcsfuse
    export GCSFUSE_REPO=gcsfuse-lsb_release -c -s
    echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install gcsfuse
掛載 GCS bucket
    gcsfuse --key-file [key] --only-dir [dir] [bucket] [destination]

例如：
gcsfuse --key-file /key.json --only-dir vote2022 sub-project /mnt/gcs

允許非 root 用戶訪問
    echo "user_allow_other" | sudo tee -a /etc/fuse.conf
    sudo gcsfuse -o allow_other --implicit-dirs --file-mode=777 --dir-mode=777 media-tools-gcs /gcs
開機自動掛載
    sh gcs-mount.sh
取消掛載
    sudo umount /media-upload-to-gcs

# 如果上面的命令失敗，可以嘗試：
sudo umount -f /media-upload-to-gcs
# 或
sudo umount -l /media-upload-to-gcs

