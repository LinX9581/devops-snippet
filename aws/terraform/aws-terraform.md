# AWS Terraform Init

* 安裝 terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

* 建立 key pair
aws ec2 create-key-pair --key-name stg-devops --query 'KeyMaterial' --output text > stg-devops.pem

* aws terraform init
cd ./devops-snippet/aws/terraform/aws-terraform-init

* 修改init.tfvars 
要指定 public key 才能 SSH 進 EC2
ssh_public_key  = ""

※ 避免之前被用過
rm -rf terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl .
terraform init
terraform apply -var-file="init.tfvars"


* 檢視建立的 EC2
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,PublicDNS:PublicDnsName,PrivateDNS:PrivateDnsName,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress}'

* 建立的資源
會依序建立 VPC, subnet, security group, EC2 instance, getway, route table, route table association, role-policy, IAM profile

* 建立的 EC2 會綁定以下環境
1. Ansible 使用者
2. 綁定 security group 包含 allow-other , allow-ssh, allow-http, allow-https
3. 綁定 role-policy

* network
1. VPC
2. Subnet
3. Internet Gateway
4. Route Table
如果用的是 network_nat.tf 會建立 NAT Gateway
會有一個 public subnet 是給 NAT 使用
再讓 private subnet 透過 NAT Gateway 連線外部

* security group
1. allow-other
2. allow-ssh
3. allow-http
4. allow-https

* iam
一個有以下 Policy 的 role : ec2-role
1. AmazonSSMManagedInstanceCore
2. AmazonSSMPatchAssociation
3. 有S3,SSM 的 Policy : s3_ssm_policy

綁定該role的profile : ec2-profile

* 查看目前建立的資源
terraform state list  

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
