https://ithelp.ithome.com.tw/articles/10238998
https://ithelp.ithome.com.tw/articles/10239692

# 注意
helm 預設 autoscaling 是關閉的

## 新增
kubectl create ns nodejs-template3
helm create nodejs-template3
cd nodejs-template3/

* 根據 Chart.yaml 去生 k8s yaml
helm install -n nodejs-template3 helm-release3 ./

# 查詢
* 查看目前 helm的 release2 以及pod
helm list -n nodejs-template3
helm list --all-namespaces
kubectl get all -n nodejs-template3

* 查看生出來的實際 yaml 長怎樣
helm -n nodejs-template3 get manifest helm-release3

* 檢查
helm lint ./

## Editor
* 會去覆蓋 value.yaml 但實際上檔案不會被改
helm -n nodejs-template3 upgrade helm-release3 --set service.type=NodePort ./
helm upgrade -n nodejs-template3 helm-release3 ./ -f values.yaml
kubectl rollout restart deployment helm-release3-nodejs-template3 -n nodejs-template3

* 可以查看異動了甚麼
helm -n nodejs-template3 get values helm-release3


# 版本控管
* 看歷史紀錄
helm history helm-release3 -n nodejs-template3
helm rollback helm-release3 -n nodejs-template3 5

## 移除
kubectl delete all --all -n nodejs-template3
helm delete -n nodejs-template3 helm-release3

## 確認結果
kdsn 查看node ip
ip:service port 即可看到 nginx



kubectl get all -n nodejs-template3


## configMap
configmap.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: nodejs-template-env
  namespace: nodejs-template2
data:
  db_host: "172.16.2.10"
  db_user: "docker"
  db_password: "00000000"

要再更改 /templates/deployment.yaml
image底下加上
envFrom:
- configMapRef:
    name: nodejs-template-env


## ref
helm configmap
https://godleon.github.io/blog/DevOps/Helm-v3-Chart-Template-Guide/

# ubuntu helm 3.9

wget https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz
tar -zxvf helm-v3.9.4-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm