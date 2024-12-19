#!/bin/bash

# 假設資料夾已經建立好 index.html 的靜態資源
BUCKET_NAME="nn-gcs-test5"
FOLDER_NAME="test-site"
REGION="asia-east1"

# 創建 bucket
echo "Creating bucket..."
gcloud storage buckets create gs://$BUCKET_NAME --location=$REGION

# 複製文件到 bucket
mkdir /devops/gcs/$FOLDER_NAME -p
echo "<html><body><h1>$BUCKET_NAME Hello World</h1></body></html>" > /devops/gcs/$FOLDER_NAME/index.html

gsutil cp -r /devops/gcs/$FOLDER_NAME gs://$BUCKET_NAME

# 設置公開訪問權限
gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME

# 為每個文件夾設置網站配置
gsutil web set -m index.html -e 404.html gs://$BUCKET_NAME/$FOLDER_NAME

# 獲取公開 URL
SITE1_URL="https://storage.googleapis.com/$BUCKET_NAME/$FOLDER_NAME/index.html"

echo "Public URL for $FOLDER_NAME: $SITE1_URL"