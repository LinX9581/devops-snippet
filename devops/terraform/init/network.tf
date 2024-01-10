variable "project_name" {
    type = string
}

locals {
  project_name = var.project_name
}

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

resource "google_compute_router" "router" {
  name    = "quickstart-router"
  network = google_compute_network.vpc_network.self_link
}

# 預設的VPC手動建立完 會連帶建立 nat&router
resource "google_compute_router_nat" "nat" {
  name                               = "quickstart-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_route" "private_network_internet_route" {
  name             = "private-network-internet"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.self_link
  next_hop_gateway = "default-internet-gateway"
  priority    = 100
}

