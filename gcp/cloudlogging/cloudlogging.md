



## 查看GCP的異動行為 包含使用者透過網頁連入SSH
resource.type="gce_instance"
protoPayload.resourceName="projects/test/zones/asia-east1-b/instances/prod-fn-servlet01"
logName="projects/test/logs/cloudaudit.googleapis.com%2Factivity"

## 查看GCP的防火牆行為

jsonPayload.rule_details.reference:("network:default/firewall:default-allow-http")
jsonPayload.connection.src_ip:("61.216.80.98")

logName:(projects/projectID/logs/compute.googleapis.com%2Ffirewall) 
AND 
jsonPayload.rule_details.reference:("network:networkName/firewall:allow-ssh") 
AND 
jsonPayload.connection.src_ip:("220.130.95.108") 
OR 
jsonPayload.connection.src_ip:("61.56.9.114") 
OR 
jsonPayload.connection.src_ip:("192.83.177.12")



logName=("projects/project_name/logs/compute.googleapis.com%2Ffirewall") 
AND jsonPayload.rule_details.reference=("network:default/firewall:default-allow-other")
AND NOT jsonPayload.connection.src_ip="61.216.130.30"

gcloud logging read "resource.type=global AND jsonPayload.rule_details.reference=\"network:nownews-prod-deploy-vpc/firewall:nownews-prod-deploy-allow-ssh\" AND timestamp>=\"2024-01-01T00:00:00Z\" AND timestamp<=\"2024-01-31T23:59:59Z\"" --project nownews-prod-deploy --limit 100 --format json
