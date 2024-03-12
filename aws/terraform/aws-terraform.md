# AWS Terraform

* 安裝 terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

* 建立 IAM roles
EC2 IAM profile 要加上建立的 IAM roles

* 建立 key pair
aws ec2 create-key-pair --key-name stg-devops --query 'KeyMaterial' --output text > stg-devops.pem

* 初始化 terraform 
terraform init
terraform apply

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
