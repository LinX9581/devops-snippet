

mkdir grafana_data prometheus-data -P
chmod 777 grafana_data prometheus-data
rsync -avh monitor@35.236.154.220:/devops/grafana_data/ /devops/grafana_data
rsync -avh monitor@172.16.2.72:/prometheus/backupdata/ /devops/prometheus-data


docker run --name alertmanager -d -p 9093:9093 -v /devops/prometheus/alertmanager:/alertmanager \
prom/alertmanager --storage.path=/tmp --config.file=/alertmanager/alert.yml

