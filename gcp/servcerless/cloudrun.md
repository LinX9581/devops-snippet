1. push to gcr and deploy to cloud run
gcloud auth activate-service-account --key-file project-name.json
gcloud auth configure-docker --quiet
gcloud config set project project-name
docker tag node-template:3.0 asia.gcr.io/project-name/node-template:3.0
docker push asia.gcr.io/project-name/node-template:3.0

gcloud run deploy my-service --image=asia.gcr.io/project-name/node-template:3.0 --region=asia-east1


## 自動擴展
是根據每個 conatiner 的 maximum number of concurrent requests 來決定是否要擴展
maximum number of concurrent requests 預設是80 
Maximum number of instances 如果是3 則能處理240個 number of concurrent requests



## 如果要讓 cloud run 可以訪問 gce 內部網路
需要在 VPC network 的 Serverless VPC access 建立connector (相當於VPN)
可以指定 gce 的 vpc network
但連線過程 會根據流量而autoscaling 所以會有額外費用