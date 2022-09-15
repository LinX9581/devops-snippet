variable "firewall_name" {
    type = string
}

locals {
  firewall_name = var.firewall_name
}

resource "google_compute_instance" "vm_instance1" {
  name         = "nginx-instance2"
  machine_type = "e2-medium"

  tags = ["${local.firewall_name}-allow-ssh","${local.firewall_name}-allow-80","${local.firewall_name}-allow-443"]

  boot_disk {
    initialize_params {
      size  = "20"
      image = "ubuntu-2004-lts"
      type  = "pd-ssd"
      # type  = "pd-balanced"
    }
  }

  metadata_startup_script = <<EOT
    sudo apt update
    sudo apt upgrade -y
    sudo apt install nginx -y
    sudo apt install net-tools -y
    sudo apt install git -y
    sudo timedatectl set-timezone Asia/Taipei
  EOT

  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.private_network.self_link
    access_config {
      network_tier = "PREMIUM"
        # 這邊空白預設會建立一個外部IP , 整個拿掉就只會有內部IP
        # 如果有建立共同對外IP , 預設是
        # nat_ip = google_compute_address.static.address
    }
  }
}
