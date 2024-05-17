1. push to artifacts and deploy to cloud run

gcloud auth activate-service-account --key-file project-name.json
gcloud config set project project-name
gcloud auth configure-docker asia-docker.pkg.dev
gcloud artifacts repositories create nodejs-repo --repository-format=docker --location=asia --description="Docker repository"
docker build -t asia-docker.pkg.dev/project-name/nodejs-repo/nodejs-template:4.5 . --no-cache
docker push asia-docker.pkg.dev/project-name/nodejs-repo/nodejs-template:4.5
gcloud run deploy my-service --image=asia-docker.pkg.dev/project-name/nodejs-repo/nodejs-template:4.6 --region=asia-east1 --platform=managed --allow-unauthenticated --memory=512Mi --cpu=1 --max-instances=1 --timeout=10m --concurrency=1 --port=3005 --set-env-vars=NODE_ENV=production
gcloud run services update my-service --service-account SERVICE_ACCOUNT

有時候沒辦法佈署是因為記憶體不夠

## 自動擴展
是根據每個 conatiner 的 maximum number of concurrent requests 來決定是否要擴展
maximum number of concurrent requests 預設是80 
Maximum number of instances 如果是3 則能處理240個 number of concurrent requests

## 如果要讓 cloud run 可以訪問 gce 內部網路
需要在 VPC network 的 Serverless VPC access 建立connector (相當於VPN)
可以指定 gce 的 vpc network
但連線過程 會根據流量而autoscaling 所以會有額外費用