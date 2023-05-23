## ArgoCD 建立
iam 可能要很大的權限才能建立 argoCD pods
因為argoCD 會建立一個service account 來管理 k8s cluster

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd

* 建立argoCD web 服務
kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 3007:443

* 取得密碼
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

127.0.0.1:3007
admin
password

* 建立ingress
https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/

## CLI 建立
argocd app create nodejs-template3 \
--repo https://github.com/LinX9581/nodejs-template3 \
--path . \
--dest-server https://kubernetes.default.svc \
--dest-namespace nodejs-template3

## ArgoCD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

## 綁定 private repo
public key to github
argoui -> setting -> connect repo -> ssh 
argocd repo add git@github.com:LinX9581/nodejs2.git --ssh-private-key-path /var/www/rsa_id

## 基本原理
ArgoCD 是走 GitOps
根據 Repo 來生成整個環境
所以原先如果已經
helm install -n nodejs-template1 helm-release1 ./
那就會變兩個相同環境 導致像是 ingress 重複而出錯

## 部屬策略
* Recreate 直接砍掉舊 等新的佈署完畢

* Ramped 新舊 逐一替換

* Blue/Green 新的好 直接全換新

* Canary 新舊並行 流量慢慢導到新的

* A/B testing 新舊並行

* Shadow
同時並行 確認完全無誤才移除舊版本

# ref
建立
https://ithelp.ithome.com.tw/articles/10268662

部屬策略
https://ithelp.ithome.com.tw/articles/10245433