
# source
https://github.com/prometheus-operator/kube-prometheus

# 安裝方式
wget https://github.com/prometheus-operator/kube-prometheus/archive/refs/tags/v0.11.0.zip
apt install unzip
unzip v0.11.0.zip
cd kube-prometheus-0.11.0

kubectl apply --server-side -f manifests/setup

kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring

kubectl create -f manifests/

# Grafana 對外 (要等所有 pod 跑完)
nohup kubectl --address 0.0.0.0 --namespace monitoring port-forward svc/grafana 3000 > nohupcmd.out 2>&1 &

kubectl get all -n monitoring


# 其他圖表
git clone https://github.com/dotdc/grafana-dashboards-kubernetes.git
cd grafana-dashboards-kubernetes

# delete
kubectl delete all --all -n monitoring