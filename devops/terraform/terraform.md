# install
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

mkdir terra
cd /terra/
terraform init
touch main.tf ..
# sample
官方
https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started

https://github.com/foyst/gcp-terraform-quickstart/blob/main/main.tf
https://www.youtube.com/watch?v=2xaZQHhNO04&ab_channel=BenFoster
https://medium.com/slalom-technology/a-complete-gcp-environment-with-terraform-c087190366f0