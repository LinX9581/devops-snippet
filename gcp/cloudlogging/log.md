jsonPayload.rule_details.reference:("network:default/firewall:default-allow-http")
jsonPayload.connection.src_ip:("61.216.80.98")


## 查看GCP的異動行為 包含使用者透過網頁連入SSH
resource.type="gce_instance"
protoPayload.resourceName="projects/test/zones/asia-east1-b/instances/prod-fn-servlet01"
logName="projects/test/logs/cloudaudit.googleapis.com%2Factivity"
