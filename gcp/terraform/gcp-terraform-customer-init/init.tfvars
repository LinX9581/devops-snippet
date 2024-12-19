project_id   = "project-name"
project_name = "project-name"

network_name   = "project-name-vpc"
network_region = "asia-east1"
subnets = {
  lb_subnet = {
    name = "project-name-lb-subvpc"
    cidr = "172.16.0.0/24"
  },
  fn_subnet = {
    name = "project-name-fn-subvpc"
    cidr = "172.16.1.0/24"
  },
  bn_subnet = {
    name = "project-name-bn-subvpc"
    cidr = "172.16.2.0/24"
  }
}

firewall_name = "project-name"
firewall_monitor_ips = ["172.16.2.1", "35.236.154.220", "218.32.45.222"]

instances = {
  prod = {
    name = "prod-project-name-01"
    type = "e2-medium"
    subnetwork = "lb_subnet"
    tags = [
      "project-name-allow-ssh",
      "project-name-allow-http",
      "project-name-allow-https",
      "project-name-allow-other"
    ]
    zone = "asia-east1-b"
    metadata = {
      ssh-keys = ""
    }
    boot_disk_size = 20
    boot_disk_type = "pd-ssd"
  },
  deploy = {
    name = "prod-deploy-01"
    type = "e2-medium"
    subnetwork = "fn_subnet"
    tags = [
      "project-name-allow-ssh",
      "project-name-allow-http",
      "project-name-allow-https",
      "project-name-allow-other"
    ]
    zone = "asia-east1-b"
    metadata = {
      ssh-keys = ""
    }
    boot_disk_size = 20
    boot_disk_type = "pd-ssd"
  }
}