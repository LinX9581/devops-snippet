#!/bin/bash

GCP_PROJECT_NAME=
AR_PROJECT_NAME=
PROJECT_NAME=
APP_VERSION=$(date +"%m_%d_%H%M%S")

# gcloud auth activate-service-account --key-file $PROJECT_NAME.json
gcloud config set project $GCP_PROJECT_NAME
gcloud auth configure-docker $AR_TARGET
gcloud auth configure-docker --quiet
gcloud artifacts repositories create $AR_PROJECT_NAME --repository-format=docker --location=asia --description="Docker repository"
docker build -t asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION .
docker push asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION


# 這邊是先用 Terraform 或 手動把 Cloud Run 建起來 再做佈版 
# secret 是用 GCP 的 secret manager , 用環境變數會直接把值寫在 cloud run 的環境變數裡面
gcloud run deploy $CLOUDRUN_SERVICE \
  --image asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$CONTAINER_NAME:$APP_VERSION \
  --platform managed \
  --region asia-east1 \
  --allow-unauthenticated \
  --tag latest \
  --remove-env-vars CLIENT_DB_URL \
  --set-secrets CLIENT_DB_URL=CLIENT_DB_URL:latest

# 切換流量到新的版本
gcloud run services update-traffic $CLOUDRUN_SERVICE \
  --region asia-east1 \
  --to-tags latest=100


# gcloud run services delete my-service5 --platform=managed --region=asia-east1