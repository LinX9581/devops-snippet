
service account 至少要 viewer 以上的權限

* 內部IP監控台灣 a b 區
```  
  - job_name: 'gce-test-project-node'
    gce_sd_configs:
      - project: 'test-project'
        zone: 'asia-east1-b' 
        port: 9100
      - project: 'test-project'
        zone: 'asia-east1-a'  
        port: 9100
    relabel_configs:
      - source_labels: [__meta_gce_instance_name]
        target_label: instance

  - job_name: 'gce-test-project-process'
    gce_sd_configs:
      - project: 'test-project'
        zone: 'asia-east1-b' 
        port: 9256
      - project: 'test-project'
        zone: 'asia-east1-a'  
        port: 9256
    relabel_configs:
      - source_labels: [__meta_gce_instance_name]
        target_label: instance
```

* 外部IP監控


  - job_name: 'gce-test-project-node'
    gce_sd_configs:
      - project: 'test-project'
        zone: 'asia-east1-b'
        port: 9100
    relabel_configs:
      - source_labels: [__meta_gce_public_ip]
        target_label: instance
      - source_labels: [__meta_gce_public_ip]
        target_label: __address__
        replacement: '${1}:9100' 

  - job_name: 'gce-test-project-process'
    gce_sd_configs:
      - project: 'test-project'
        zone: 'asia-east1-b'
        port: 9256
    relabel_configs:
      - source_labels: [__meta_gce_public_ip]
        target_label: instance
      - source_labels: [__meta_gce_public_ip]
        target_label: __address__
        replacement: '${1}:9256' 




## 參考
__meta_gce_public_ip