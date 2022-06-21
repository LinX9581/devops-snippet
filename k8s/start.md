# K8S
4個元件
Pod、Worker Node、Master Node、Cluster
api,vps,
[pusg image to gkr 官方文件](https://cloud.google.com/container-registry/docs/pushing-and-pulling)

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
docker tag linx9581/calendar:0.1 gcr.io/phonic-entity-320408/calendar:0.1
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

# 運行在GKE
先在GKE建立cluster
## 授權後 連結到該cluster
gcloud auth login
gcloud config set project k88888888s-329606
gcloud container clusters get-credentials cluster-2 --zone=asia-east1-a --project=k88888888s-329606

* 查看node狀態
kubectl get node -o wide 

* 簡化指令
nano ~/.bashrc

```
alias k8s='kubectl'
## get
alias kgp='kubectl get pod -o wide'
alias kgn='kubectl get node'
alias kgd='kubectl get deployment'
alias kgs='kubectl get service'
alias kgh='kubectl get HorizontalPodAutoscaler'
alias kgl='kubectl logs'
alias kgr='kubectl get rs'
alias kgd='kubectl get deployment'

## create
alias kcy='kubectl apply -f'

## describe
alias kdsp='kubectl describe pod'
alias kdsn='kubectl describe node'
alias kdsd='kubectl describe deployment'
alias kdss='kubectl describe service'
alias kdsh='kubectl describe HorizontalPodAutoscaler'

## delete
alias kdd='kubectl delete deployment'
alias kds='kubectl delete service'
alias kdh='kubectl delete HorizontalPodAutoscaler'
alias kdn='kubectl delete node'
alias kdp='kubectl delete pod'

## monit
alias ktp='kubectl top pod'
alias ktn='kubectl top node'
```