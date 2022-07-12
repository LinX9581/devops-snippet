# install
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

gcloud auth activate-service-account  --key-file terra2.json
gcloud config set project terra-355307
gcloud compute instances list

# terraform init
mkdir terra
cd /terra/
terraform init
touch main.tf ..
換專案則換資料夾初始化
terraform plan
terraform apply

# terraform import
1. 手動建立 並 import
假設原有 VM名稱: import-test
要建立一個相對的 tf file
terraform import google_compute_instance.import-test import-test
```
resource "google_compute_instance" "import-test" {
  name         = "import-test"
  machine_type = "e2-medium"

  tags = ["nownews-allow-ssh","nownews-allow-80","nownews-allow-443","nownews-allow-others"]

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

2. 自動化工具 terraformer
export PROVIDER=google
curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-darwin-amd64
chmod +x terraformer-${PROVIDER}-darwin-amd64
sudo mv terraformer-${PROVIDER}-darwin-amd64 /usr/local/bin/terraformer

https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/gcp.md
https://arivictor.medium.com/turn-your-gcp-project-into-terraform-with-terraformer-cli-eeec36cbe0d8


# sample
官方
https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started

https://github.com/foyst/gcp-terraform-quickstart/blob/main/main.tf
https://www.youtube.com/watch?v=2xaZQHhNO04&ab_channel=BenFoster
https://medium.com/slalom-technology/a-complete-gcp-environment-with-terraform-c087190366f0