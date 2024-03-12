variable "firewall_name" {
    type = string
}

locals {
  firewall_name = var.firewall_name
}

resource "google_compute_address" "static_ip" {
  name   = "instance3"
  region = "asia-east1"
}

resource "google_compute_instance" "instance3" {
  name         = "instance3"
  machine_type = "e2-small"

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
  EOT

  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.private_network.self_link
    access_config {
      network_tier = "PREMIUM"
      nat_ip = google_compute_address.static_ip.address
      # 這邊空白預設會建立一個外部IP , 整個拿掉就只會有內部IP
    }
  }

#   deletion_protection = "false"

  service_account {
    email  = ""
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  metadata                = {
   "ssh-keys" = <<-EOT
username:key
    EOT
  }

  labels = {
    "gce" = "instance3"
  }

  tags = ["${local.firewall_name}-allow-ssh","${local.firewall_name}-allow-80","${local.firewall_name}-allow-443","${local.firewall_name}-allow-other"]
  zone = "asia-east1-b"
}
