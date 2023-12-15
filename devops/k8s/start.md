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

## push Imgae
```
權限、時區設定
gcloud auth login
sudo usermod -a -G docker ${USER}
gcloud auth configure-docker
gcloud config set project react-native-oauth-da314
gcloud config set project [YOUR_PROJECT_ID]
gcloud config set compute/zone asia-east1-b
```

* image push to docker hub
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

* image push to gcr
```
gcloud auth activate-service-account --key-file json
gcloud auth configure-docker
docker tag linx9581/calendar:0.1 asia.gcr.io/phonic-entity-320408/calendar:0.1
docker tag [SOURCE_IMAGE] [HOSTNAME]/[PROJECT-ID]/[IMAGE]:[TAG]

docker push gcr.io/phonic-entity-320408/calendar:0.1
docker push [HOSTNAME]/[PROJECT-ID]/[IMAGE]:[TAG]
```

* image push to registry

docker tag php-nn:7.4 <您的 VM IP 或域名>:5000/php-nn:7.4
docker push <您的 VM IP 或域名>:5000/php-nn:7.4


要讓 Docker 認可 Registry ( Client Server 都要)
/etc/docker/daemon.json
{
  "insecure-registries" : ["172.16.200.13:3008"]
}
sudo systemctl restart docker
