# hot reload
curl -X POST http://localhost:9090/-/reload
curl -X POST http://localhost:9093/-/reload

## Step
1. 修改 monitor.sh 環境變數
sh monitor.sh

2. 建立 告警
* 範例是 Nodejs 串接 Telegram Bot
devops/monit/webhook

* 完整告警規則參考
devops/monit/grafana-prometheus-alertmanager/prometheus/alertmanager/rules.yml

* 官方規則參考
https://awesome-prometheus-alerts.grep.to/rules.html#mysql

3. 建立 Grafana 圖表
Dashboard id 7362 -> mysql
Dashboard id 12708 -> nginx
Dashboard id 2587 -> K6
Dashboard id 893 -> container
Dashboard id 11074 -> vm
Dashboard id 13659 -> blackbox_exporter
Dashboard id 7362 -> mysql 
Dashboard id 13882 -> process_exporter

## prometheus 參數
以下範例會保留數據90天 並且資料備份在 /devops/prometheus-data

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

* Prometheus migration
mkdir /devops/prometheus-data -p
chmod 777 prometheus-data

rsync -avh monitor@ip:/devops/prometheus-data/ /devops/prometheus-data
重新執行 container

## Grafana 外掛安裝
* 安裝圖表
docker exec -it grafana /bin/bash
grafana cli plugins install grafana-worldmap-panel
grafana cli plugins install marcusolsson-treemap-panel
grafana cli plugins install grafana-piechart-panel

restart container 



# K8S
參考
https://github.com/prometheus-operator/prometheus-operator/issues/135
https://itw01.com/QQJP5EI.html
# nginx 圖表
https://grafana.com/grafana/dashboards/11190
https://grafana.com/grafana/dashboards/2292
https://www.gushiciku.cn/pl/g4XZ/zh-tw