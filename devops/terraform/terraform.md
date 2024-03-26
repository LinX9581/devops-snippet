# Install
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

## GCP 初始化範例
./devops-snippet/gcp/terraform/init

## AWS 初始化範例
./devops-snippet/aws/terraform/init

## 現有專案導入terraform
1. 自動化工具 terraformer
export PROVIDER=google
curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64
chmod +x terraformer-${PROVIDER}-linux-amd64
sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer

假設
GCP 專案名稱: linx
AWS Region: ap-northeast-1

* GCP import

cd ./devops-snippet/devops/terraform/gcp-provider/
terraform init
terraformer import google --resources=instances,networks,subnetworks,firewall --connect=true --regions=asia-east1 --projects=linx
cd linx/generated/gcp/instances
terraform state replace-provider -auto-approve "registry.terraform.io/-/google" "hashicorp/google"
terraform init
terraform apply

terraformer import google --resources=cloud_run --connect=true --regions=asia-east1 --projects=linx

※ terraformer 的 bug, provider 預設會是 Goolge 要改成 hashicorp/google

* AWS import
cd ./devops-snippet/devops/terraform/aws-provider/
terraform init
要確保 aws configure 有設定 執行的VM必須有權限
terraformer import aws --resources=ec2_instance --regions=ap-northeast-1
cd projectname/generated/aws/ec2_instance
terraform state replace-provider -auto-approve "registry.terraform.io/-/aws" "hashicorp/aws"
terraform init
terraform apply

terraformer import aws --resources=sg --regions=ap-northeast-1

https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md




## 手動建立 import
假設原有 VM名稱: import-test
要建立一個相對的 tf file
terraform import google_compute_instance.import-test import-test
```
resource "google_compute_instance" "import-test" {
  name         = "import-test"
  machine_type = "e2-medium"

  tags = ["test-allow-ssh","test-allow-80","test-allow-443","test-allow-others"]

  boot_disk {
    initialize_params {
      size  = "10"
      image = "ubuntu-2004-lts"
      type  = "pd-ssd"
    }
  }

  # 這拿掉會需要停止更新
  service_account {
    email  = "699260539650-compute@developer.gserviceaccount.com"
    scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring.write",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append",
      ]
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.private_network.self_link
    access_config {
      # IP要和原來的一樣 否則會砍掉重練
      nat_ip = "34.81.229.202"
      network_tier = "PREMIUM"
    }
  }
}
```
看看VM是否會被砍掉重練
terraform plan
terraform apply


* terraformer吃的是key是環境變數 GOOGLE_APPLICATION_CREDENTIALS=/gcp-terraform/terra-test/terra-355307-6c259aff1e19.json
* import iam 需允許 Identity and Access Management (IAM) API
* 如果外層版本太舊 import出來的 都會是低版本 需要下面指令更新
cd /terraformer/generated/google/terra-test-353202/instances/asia-east1
terraform state replace-provider -auto-approve "registry.terraform.io/-/google" "hashicorp/google"

* import armor
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_security_policy#import

https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/gcp.md
https://arivictor.medium.com/turn-your-gcp-project-into-terraform-with-terraformer-cli-eeec36cbe0d8
https://www.youtube.com/watch?v=2GE0GAsIz_M&ab_channel=GoogleCloudTech


# sample
官方
https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started

https://github.com/foyst/gcp-terraform-quickstart/blob/main/main.tf
https://www.youtube.com/watch?v=2xaZQHhNO04&ab_channel=BenFoster
https://medium.com/slalom-technology/a-complete-gcp-environment-with-terraform-c087190366f0