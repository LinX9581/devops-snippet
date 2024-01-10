variable "project_name" {
    type = string
}

locals {
  project_name = var.project_name
}


# firewall

resource "google_compute_firewall" "allow-ssh" {
  name    = "${local.project_name}-allow-ssh"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20", "173.194.93.0/24", "0.0.0.0/0"]

#   都不下=全吃
}

resource "google_compute_firewall" "allow-80" {
  name    = "${local.project_name}-allow-80"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "0.0.0.0/0"]
  target_tags = ["${local.project_name}-allow-80"]
}

resource "google_compute_firewall" "allow-443" {
  name    = "test1-allow-443"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags = ["${local.project_name}-allow-443"]
}