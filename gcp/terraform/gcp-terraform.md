# GCP Terraform Init

* 安裝 terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

## 初始化GCP專案
讓 VM 預設 Service Account 有相對應權限或直接給 Editor 之後再調回去
gcloud config set project project_name

* gcp terraform init
cd ./devops-snippet/gcp/terraform/gcp-terraform-init
※ 避免之前被用過
rm -rf terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl .terraform
terraform init
terraform apply -var-file="init.tfvars"

* 檢視建立的 VM
gcloud compute instances list

* 建立的資源
會建立 vpc subnetwork firewall vm

## GCP Terraformer
* terraformer install
export PROVIDER=gcp
curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64
chmod +x terraformer-${PROVIDER}-linux-amd64
sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer

* GCP import
cd ./devops-snippet/devops/terraform/gcp-provider/
terraform init
terraformer import google --resources=instances,networks,subnetworks,firewall --connect=true --regions=asia-east1 --projects=linx
cd linx/generated/gcp/instances
terraform state replace-provider -auto-approve "registry.terraform.io/-/google" "hashicorp/google"
terraform init
terraform apply

## iam 的基本權限
* 異動網路
roles/compute.networkAdmin: This role grants the ability to manage network resources, including firewalls.
roles/compute.securityAdmin: This role grants the ability to manage security-related resources, including firewalls.
中文:
安全管理員 網路管理員