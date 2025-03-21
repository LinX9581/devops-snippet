
aws configure (機器本身有權限 設定檔就不用另外設置)
建立的IAM 要建立 Access key ID 和 Secret access key 以及 region ap-northeast-1
IAM -> User -> Username -> Security credentials -> Create access key -> Application running outside AWS
資安漏洞就直接用上面那把
否則就是另外建最低權限的 IAM
aws iam create-user --user-name ec2-monitor-only
aws iam attach-user-policy \
    --user-name ec2-monitor-only \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
aws iam create-access-key --user-name ec2-monitor-only

但 container 有低機率就是讀不到 aws configure 的設定 那就直接重啟 container 並且直接指定 key
docker run --name prometheus -d -p 9090:9090 \
  -v /devops/backupdata/prometheus:/prometheus-data \
  -v /devops/ansible-deploy-monitor/prometheus:/etc/prometheus \
  -e AWS_ACCESS_KEY_ID= \
  -e AWS_SECRET_ACCESS_KEY= \
  -e AWS_DEFAULT_REGION=ap-northeast-1 \
  prom/prometheus \
  --web.enable-lifecycle \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus-data \
  --storage.tsdb.retention.time=90d

- job_name: 'ec2-instance'
  ec2_sd_configs:
    - region: 'ap-northeast-1'
      port: 9100
  relabel_configs:
    - source_labels: [__meta_ec2_instance_state]
      regex: 'running'
      action: 'keep'
    - source_labels: [__meta_ec2_instance_id]
      target_label: instance_id
    - source_labels: [__meta_ec2_tag_Name]
      target_label: instance_name
    - source_labels: [__meta_ec2_public_ip]
      target_label: public_ip
    - source_labels: [__meta_ec2_public_ip]
      target_label: __address__
      replacement: '${1}:9100'

- job_name: 'ec2-process'
  ec2_sd_configs:
    - region: 'ap-northeast-1'
      port: 9256
  relabel_configs:
    - source_labels: [__meta_ec2_instance_state]
      regex: 'running'
      action: 'keep'
    - source_labels: [__meta_ec2_instance_id]
      target_label: instance_id
    - source_labels: [__meta_ec2_tag_Name]
      target_label: instance_name
    - source_labels: [__meta_ec2_public_ip]
      target_label: public_ip
    - source_labels: [__meta_ec2_public_ip]
      target_label: __address__
      replacement: '${1}:9256'