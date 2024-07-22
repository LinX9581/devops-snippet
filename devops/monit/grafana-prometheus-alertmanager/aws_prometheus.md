
aws configure
建立的IAM 要建立 Access key ID 和 Secret access key 以及 region ap-northeast-1
IAM -> User -> Username -> Security credentials -> Create access key -> Application running outside AWS



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
      access_key: 'AKIATNEZWMHCT2YZGIE3'
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