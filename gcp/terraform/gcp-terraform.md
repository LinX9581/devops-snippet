# Step

## 初始化GCP專案
讓 VM 預設 Service Account 有相對應權限或直接給 Editor 之後再調回去
gcloud config set project project_name
gcloud compute instances list


cd ./devops-snippet/gcp/terraform/gcp-terraform-init

* 設定 terraform 變數
cat>init.tfvars<<EOF
project_id = "linx"
project_name = "linx"
firewall_name = "linx"
EOF

* 確保之前沒被用過
rm -rf terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl .terraform
terraform init
terraform apply -var-file="init.tfvars"

會建立 vpc subnetwork firewall vms




## iam 的基本權限
* 異動網路
roles/compute.networkAdmin: This role grants the ability to manage network resources, including firewalls.
roles/compute.securityAdmin: This role grants the ability to manage security-related resources, including firewalls.
中文:
安全管理員 網路管理員