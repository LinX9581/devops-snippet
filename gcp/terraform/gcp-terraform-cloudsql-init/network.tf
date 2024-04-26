resource "google_compute_network" "vpc_network" {
  name                    = "${local.project_name}-vpc"
  auto_create_subnetworks = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "private_network" {
  name          = "${local.project_name}-subvpc"
  ip_cidr_range = "172.16.2.0/24"
  region        = "asia-east1"
  network       = google_compute_network.vpc_network.self_link
}