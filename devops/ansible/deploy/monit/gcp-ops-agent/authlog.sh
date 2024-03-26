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
    user_history:
      type: files
      include_paths:
      - /var/log/.bash_history  
    home_history:
      type: files
      include_paths:
      - /home/*/.bash_history   
  service:
    pipelines:
      default_pipeline:
        receivers: [syslog]
      history_pipeline:  # 新增的pipeline
        receivers: [user_history]
      home_history_pipeline:  # 新增的pipeline
        receivers: [home_history]

metrics:
  receivers:
    hostmetrics:
      type: hostmetrics
      collection_interval: 180s
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

sleep 3

