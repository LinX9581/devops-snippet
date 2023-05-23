# Monitor

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
kubectl create namespace monitor
helm uninstall prometheus -n monitor
helm uninstall grafana -n monitor
kubectl get all -n monitor

# Prometheus

* 客製化自己的 yaml 從這邊改
https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/prometheus/values.yaml
helm install -f values.yaml prometheus prometheus-community/prometheus -n monitor

# Grafana
helm install grafana grafana/grafana -n monitor

* 取得 pod name
export POD_NAME=$(kubectl get pods --namespace monitor -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")

* 對外
kubectl --namespace monitor port-forward $POD_NAME 3000

* 取得密碼
kubectl get secret --namespace monitor grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo