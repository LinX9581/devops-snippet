1. 建立 topic
gcloud pubsub topics create test-topic

2. 建立 log router sink

* 主要收集
網路流量/VPC 流量 (Netflow / VPC Flow)
防火牆 (Firewall)
雲端稽核 (Cloud Audit)
身份驗證與授權 (IDP)
現成/客製化 - 身份驗證與授權 (COTS / Custom - IDP)

resource.type="gce_subnetwork" AND (
  log_id("compute.googleapis.com/vpc_flows") OR
  log_id("compute.googleapis.com/firewall")
)
OR resource.type="gce_firewall_rule"
OR log_id("cloudaudit.googleapis.com/activity")
OR log_id("cloudaudit.googleapis.com/data_access")
OR log_id("cloudaudit.googleapis.com/system_event")
OR log_id("cloudaudit.googleapis.com/policy")
OR protoPayload.serviceName="iam.googleapis.com"
OR protoPayload.serviceName="cloudidentity.googleapis.com"
OR protoPayload.serviceName="identitytoolkit.googleapis.com"
OR protoPayload.serviceName="iap.googleapis.com"

