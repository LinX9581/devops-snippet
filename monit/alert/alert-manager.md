參考文件
https://grafana.com/blog/2020/02/25/step-by-step-guide-to-setting-up-prometheus-alertmanager-with-slack-pagerduty-and-gmail/

docker run --name alertmanager -d -p 9093:9093 -v /prometheus/alertmanager:/alertmanager \
prom/alertmanager --storage.path="/tmp" --web.listen-address=":9093" --cluster.listen-address= --config.file=/alertmanager/alertmanager.yml

docker run --name alertmanager -d -p 9093:9093 -v /prometheus/alertmanager:/alertmanager \
prom/alertmanager --storage.path="/tmp" --config.file=/alertmanager/alertmanager.yml

docker run -d -p 9090:9090 -v /prometheus:/etc/prometheus \
prom/prometheus --web.enable-lifecycle --config.file=/etc/prometheus/prometheus.yml

curl -X POST http://localhost:9090/-/reload
curl -X POST http://localhost:9093/-/reload