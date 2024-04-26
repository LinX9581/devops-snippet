variable "firewall_name" {
    type = string
}

locals {
  firewall_name = var.firewall_name
}

resource "google_compute_address" "prod-01" {
  name   = "prod-${local.project_name}-01"
  region = "asia-east1"
}

resource "google_compute_instance" "instance1" {
  name         = "prod-${local.project_name}-01"
  machine_type = "e2-medium"

  tags = ["${local.firewall_name}-allow-ssh","${local.firewall_name}-allow-http","${local.firewall_name}-allow-https","${local.firewall_name}-allow-other"]

  boot_disk {
    initialize_params {
      size  = "20"
      image = "ubuntu-2204-lts"
      type  = "pd-ssd"
      # type  = "pd-balanced"
    }
  }

  metadata_startup_script = <<EOF

EOF 

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
  zone = "asia-east1-b"

  metadata                = {
   "ssh-keys" = <<-EOT

    EOT
  }

  # service_account {
  #   email  = "${local.project_name}-gce@${local.project_id}.iam.gserviceaccount.com"
  #   scopes = [
  #     "https://www.googleapis.com/auth/cloud-platform",
  #   ]
  # }

  labels = {
    "prod-${local.project_name}-01" = "prod-${local.project_name}-01"
  }
}

# resource "google_compute_address" "stg-01" {
#   name   = "stg-${local.project_name}-01"
#   region = "asia-east1"
# }

# resource "google_compute_instance" "instance2" {
#   name         = "stg-${local.project_name}-01"
#   machine_type = "e2-medium"

#   tags = ["${local.firewall_name}-allow-ssh","${local.firewall_name}-allow-http","${local.firewall_name}-allow-https","${local.firewall_name}-allow-other"]

#   boot_disk {
#     initialize_params {
#       size  = "20"
#       image = "ubuntu-2204-lts"
#       type  = "pd-ssd"
#       # type  = "pd-balanced"
#     }
#   }

#   metadata_startup_script = <<EOF

# EOF 

#   network_interface {
#     network = google_compute_network.vpc_network.self_link
#     subnetwork = google_compute_subnetwork.private_network.self_link
#     access_config {
#       network_tier = "PREMIUM"
#         # 這邊空白預設會建立一個外部IP , 整個拿掉就只會有內部IP
#         # 如果有建立共同對外IP , 預設是
#         # nat_ip = google_compute_address.static.address
#     }
#   }
#   zone = "asia-east1-b"

#   metadata                = {
#    "ssh-keys" = <<-EOT
   
#     EOT
#   }

#   # service_account {
#   #   email  = "${local.project_name}-gce@${local.project_id}.iam.gserviceaccount.com"
#   #   scopes = [
#   #     "https://www.googleapis.com/auth/cloud-platform",
#   #   ]
#   # }

#   labels = {
#     "stg-${local.project_name}-01" = "stg-${local.project_name}-01"
#   }
# }