docker run --name prometheus -d -p 9090:9090 -v /devops/backupdata/prometheus:/prometheus-data -v /devops/ansible-deploy-monitor/prometheus:/etc/prometheus prom/prometheus --web.enable-lifecycle --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus-data

要確保資料是沒有權限的，否則 docker 會沒權限
chown nobody:nogroup backupdata/ -R