https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent/third-party/nginx?hl=zh-cn


預設的iam帳戶要有logging monitoring的權限
##  加 - /var/log/auth.log 集合到 syslog
#!/bin/bash

cat>/etc/google-cloud-ops-agent/config.yaml<<EOF
logging:
  receivers:
    syslog:
      type: files
      include_paths:
      - /var/log/messages
      - /var/log/syslog
      - /var/log/auth.log
  service:
    pipelines:
      default_pipeline:
        receivers: [syslog]
metrics:
  receivers:
    hostmetrics:
      type: hostmetrics
      collection_interval: 30s
  processors:
    metrics_filter:
      type: exclude_metrics
      metrics_pattern: []
  service:
    pipelines:
      default_pipeline:
        receivers: [hostmetrics]
        processors: [metrics_filter]
EOF

sudo service google-cloud-ops-agent restart
sleep 5

