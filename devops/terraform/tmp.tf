resource "google_compute_network" "vpc_network" {
  name                    = "vpc"
  auto_create_subnetworks = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "private_network" {
  name          = "private-network"
  ip_cidr_range = "172.16.2.0/24"
  region        = "asia-east1"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_instance" "vm_instance" {
  name         = "nginx-instance2"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      size  = "20"
      image = "ubuntu-2004-lts"
      type  = "pd-ssd"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.private_network.self_link
    access_config {
      network_tier = "PREMIUM"
    }
  }
}