1. push to artifacts and deploy to cloud run

```
GCP_PROJECT_NAME=gcp_pj
AR_PROJECT_NAME=nodejs-repo1
PROJECT_NAME=nodejs-template
APP_VERSION=1.7
CLOUDRUN_SERVICE=my-service7

gcloud config set project $GCP_PROJECT_NAME
gcloud auth configure-docker asia-docker.pkg.dev

gcloud artifacts repositories create $AR_PROJECT_NAME --repository-format=docker --location=asia --description="Docker repository"
docker build -t asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION .
docker push asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION

gcloud run deploy $CLOUDRUN_SERVICE \
    --image=asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION \
    --region=asia-east1 \
    --platform=managed \
    --allow-unauthenticated \
    --memory=512Mi \
    --cpu=1 \
    --max-instances=3 \
    --timeout=10m \
    --concurrency=1 \
    --set-env-vars=db_user=dev,db_password=00000000
```

有時候沒辦法佈署是因為記憶體不夠

## 自動擴展
是根據每個 conatiner 的 maximum number of concurrent requests 來決定是否要擴展
maximum number of concurrent requests 預設是80 
Maximum number of instances 如果是3 則能處理240個 number of concurrent requests

## 如果要讓 cloud run 可以訪問 gce 內部網路
需要在 VPC network 的 Serverless VPC access 建立 connector (相當於VPN)
可以指定 gce 的 vpc network
但連線過程 會根據流量而autoscaling 所以會有額外費用

vpc connector 會建立一台機器來連接 cloudrun 和 gce 
如果流量夠大 vpc connector 資源也要夠大
gcloud compute networks vpc-access connectors create <CONNECTOR_NAME> \
    --region=asia-east1 \
    --network=nownews-analytics-vpc \
    --range=10.8.0.0/28 \
    --min-instances=2 \
    --max-instances=10 \
    --machine-type=e2-micro

