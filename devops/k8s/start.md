# 運行在GKE
先在GKE建立cluster
## 授權後 連結到該cluster

* 取得SA授權
gcloud auth activate-service-account --key-file jsonPath
gcloud config set project terra-test-353202

* 先裝SDK 再裝kubectl
https://cloud.google.com/sdk/docs/install-sdk#linux

curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-419.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-419.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
source ~/.bashrc
gcloud components install kubectl

* gcloud create cluster
gcloud container clusters create linxgke --spot

* 先手動建立GKE Cluster 再遠端連接
gcloud container clusters get-credentials linx-gke --zone=asia-east1 --project=k8s-2022-09-05

## 建立 Docker Image

## 上傳 Imgae to GKR
```
權限、時區設定
gcloud auth login
sudo usermod -a -G docker ${USER}
gcloud auth configure-docker
gcloud config set project react-native-oauth-da314
gcloud config set project [YOUR_PROJECT_ID]
gcloud config set compute/zone asia-east1-b
```

image push to docker hub
```
需要先改imagename to 帳戶名稱/imagesname
docker tag calendar:0.1 linx9581/calendar:0.1

就可以push 到docker uhb
docker push linx9581/calendar:0.1
```
image pull from docker hub
```
docker pull linx9581/calendar:0.1
```

image push to gcr
```
gcloud auth activate-service-account --key-file json
gcloud auth configure-docker
docker tag linx9581/calendar:0.1 asia.gcr.io/phonic-entity-320408/calendar:0.1
docker tag [SOURCE_IMAGE] [HOSTNAME]/[PROJECT-ID]/[IMAGE]:[TAG]

docker push gcr.io/phonic-entity-320408/calendar:0.1
docker push [HOSTNAME]/[PROJECT-ID]/[IMAGE]:[TAG]
```

## 安裝 Minukube
他需要運行在 virtual box or docker
要用docker建立Minikube需要root權限使用者，且不能用root
建立完 minikube 會起一個container
minikube ssh 連進去後裡面也會有docker環境 裝了一堆k8s container
* 創建 root 使用者
```
adduser dev
# password@7
usermod -aG sudo dev
su - dev

sudo groupadd docker
sudo usermod -aG docker $USER
```
* 安裝
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube status
```