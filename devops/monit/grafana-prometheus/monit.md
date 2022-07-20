# 概要
1. 要監控的VM裝 agent
exporter.md 有各個監控指標
mysql,nginx,node,cadvisor,redis-exporter  -> export to prometheus

k6.sh -> export to influxdb

2. 建立 grafana&promethues
grafana.md , prometheus.md

3. Grafana連線
prometheus,mysql,influxdb

4. Grafana 建立圖表
Dashboard id 7362 -> mysql
Dashboard id 12708 -> nginx
Dashboard id 2587 -> K6
Dashboard id 893 -> container
Dashboard id 11074 -> vm


# K8S
參考
https://github.com/prometheus-operator/prometheus-operator/issues/135
https://itw01.com/QQJP5EI.html
# nginx 圖表
https://grafana.com/grafana/dashboards/11190
https://grafana.com/grafana/dashboards/2292
https://www.gushiciku.cn/pl/g4XZ/zh-tw