resource "google_compute_instance" "tfer--mysql-update-partition" {
  boot_disk {
    initialize_params {
      size  = "20"
      image = "ubuntu-2004-lts"
      type  = "pd-ssd"
      # type  = "pd-balanced"
    }  
  }

  can_ip_forward = "false"

  confidential_instance_config {
    enable_confidential_compute = "false"
  }

  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "e2-medium"

  name = "mysql-update-partition"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    network            = "https://www.googleapis.com/compute/v1/projects/k8s-2022-09-05/global/networks/default"
    network_ip         = "10.140.0.5"
    queue_count        = "0"
    stack_type         = "IPV4_ONLY"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/k8s-2022-09-05/regions/asia-east1/subnetworks/default"
    subnetwork_project = "k8s-2022-09-05"
  }


  project = "k8s-2022-09-05"
  zone = "asia-east1-b"
}
