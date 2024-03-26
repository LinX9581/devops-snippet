# AWS Terraform Init

* 安裝 terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

* 建立 IAM roles
EC2 IAM profile 要加上建立的 IAM roles

* 建立 key pair
aws ec2 create-key-pair --key-name stg-devops --query 'KeyMaterial' --output text > stg-devops.pem

* aws terraform init
cd ./devops-snippet/aws/terraform/aws-terraform-init
※ 避免之前被用過
rm -rf terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl .
terraform init
terraform apply -var-file="init.tfvars"

* 檢視建立的 EC2
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,PublicDNS:PublicDnsName,PrivateDNS:PrivateDnsName,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress}'

* 建立的資源
會依序建立 VPC, subnet, security group, EC2 instance, getway, route table, route table association

* EC2 會建立 以下
1. Ansible 使用者
2. 上面建立的 Private SSH Key 
3. 綁定 security group 包含 allow-other , allow-ssh, allow-http, allow-https
4. 綁定 role-policy 建立的 IAM Proflie

* network
1. VPC
2. Subnet
3. Internet Gateway
4. Route Table

* security group
1. allow-other
2. allow-ssh
3. allow-http
4. allow-https


## AWS Terraformer

* terraformer install
export PROVIDER=aws
curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64
chmod +x terraformer-${PROVIDER}-linux-amd64
sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer

* AWS import
cd ./devops-snippet/aws/terraform/aws-provider
terraform init
要確保 aws configure 有設定 執行的VM必須有權限
terraformer import aws --resources=ec2_instance --regions=ap-northeast-1
cd projectname/generated/aws/ec2_instance
terraform state replace-provider -auto-approve "registry.terraform.io/-/aws" "hashicorp/aws"
terraform init
terraform apply

terraformer import aws --resources=sg --regions=ap-northeast-1
