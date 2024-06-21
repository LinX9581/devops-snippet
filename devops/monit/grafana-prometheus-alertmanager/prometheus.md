# hot reload
curl -X POST http://localhost:9090/-/reload
curl -X POST http://localhost:9093/-/reload

## Step
1. 修改設定檔
* 修改 prometheus IP, GCP 專案名稱
sed -i 's/172.16.97.9/prometheus-ip/g' devops/monit/grafana-prometheus-alertmanager/prometheus/prometheus.yml
sed -i 's/project-name/GCP-Project-ID/g' devops/monit/grafana-prometheus-alertmanager/prometheus/prometheus.yml

* 修改預警要打的 webhook
sed -i 's|http://127.0.0.1:3500/prome|http://example.com/webhook|g' devops/monit/grafana-prometheus-alertmanager/prometheus/alertmanager/alert.yml

## 建立 prometheus container
數據另外備份在主機、數據保存90天
讓 container 擁有GCP權限

mkdir -p /devops/prometheus-data
chmod 777 /devops/prometheus-data
```
docker run --name prometheus -d -p 9090:9090 \
  -v /devops/prometheus-data:/prometheus-data \
  -v /devops/prometheus:/etc/prometheus \
  prom/prometheus \
  --web.enable-lifecycle \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus-data \
  --storage.tsdb.retention.time=90d
```

* 確認版本
curl 127.0.0.1:9090/api/v1/status/buildinfo

## 建立 alertmanager container

```
docker run --name alertmanager -d -p 9093:9093 \
  -v /devops/prometheus/alertmanager:/alertmanager \
  prom/alertmanager \
  --storage.path=/tmp \
  --config.file=/alertmanager/alert.yml
```

## 建立 grafana container
```
docker run --name=grafana1 -d -p 3000:3000 \
    grafana/grafana:10.4.4 

```

* 安裝圖表
docker exec -it grafana /bin/bash
grafana cli plugins install grafana-worldmap-panel
grafana cli plugins install marcusolsson-treemap-panel
grafana cli plugins install grafana-piechart-panel