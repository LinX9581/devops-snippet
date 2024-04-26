# hot reload
curl -X POST http://localhost:9090/-/reload
curl -X POST http://localhost:9093/-/reload

docker run --name prometheus \  
           -d \                 
           -p 9090:9090 \       
           -v /devops/backupdata/prometheus:/prometheus-data \  # 主機上的 /devops/backupdata/prometheus 目錄映射到容器的 /prometheus-data
           -v /devops/ansible-deploy-monitor/prometheus:/etc/prometheus \  # 主機上的 /devops/ansible-deploy-monitor/prometheus 目錄映射到容器的 /etc/prometheus
           prom/prometheus \    # 使用 prom/prometheus 映像來運行容器
           --web.enable-lifecycle \  # 啟用 Prometheus 的生命週期管理功能
           --config.file=/etc/prometheus/prometheus.yml \  # 指定 Prometheus 的配置文件
           --storage.tsdb.path=/prometheus-data  # 指定 Prometheus 的時間序列數據庫存儲路徑
           --storage.tsdb.retention.time=90d


要確保資料是沒有權限的，否則 docker 會沒權限
chown nobody:nogroup backupdata/ -R