# 先停掉並移除舊容器
docker rm -f tempo
# 修改目錄擁有者為 Tempo 容器內的 UID (10001)
mkdir -p /devops/monitor-data/tempo-data
mkdir -p /devops/tempo
chown -R 10001:10001 /devops/monitor-data/tempo-data

cat>/devops/tempo/tempo-config.yaml<<EOF
server:
  http_listen_port: 3200

distributor:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: "0.0.0.0:4317"
        http:
          endpoint: "0.0.0.0:4318"

ingester:
  max_block_duration: 5m

compactor:
  compaction:
    block_retention: 48h

storage:
  trace:
    backend: local
    wal:
      path: /var/tempo/wal
    local:
      path: /var/tempo/blocks

EOF

* Docker cmd
docker run -d --name tempo \
  --restart=always \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 3200:3200 \
  -v /devops/ansible-deploy-monitor/grafana-loki-promtail-tempo/tempo-config.yaml:/etc/tempo/tempo.yaml:ro \
  -v /devops/monitor-data/tempo-data:/var/tempo \
  grafana/tempo:2.10.0 \
  -config.file=/etc/tempo/tempo.yaml