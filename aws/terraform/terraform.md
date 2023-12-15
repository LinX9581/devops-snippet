# AWS Terraform

* 安裝 terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

* 建立 IAM roles
EC2 IAM profile 要加上建立的 IAM roles

* 初始化 terraform 
main.tf
network.tf

terraform init
terraform apply

會依序建立 VPC, subnet

