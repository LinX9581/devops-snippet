# firewall
variable "monitor_ip" {
  description = ""
  type        = list(string)
  default     = ["172.16.2.1"]
}

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

  source_ranges = concat(
    ["35.235.240.0/20", "173.194.93.0/24"],
    var.monitor_ip,
  )
#   都不下=全吃
}

resource "google_compute_firewall" "allow-http" {
  name    = "${local.project_name}-allow-http"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "0.0.0.0/0"]
  target_tags = ["${local.project_name}-allow-http"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "${local.project_name}-allow-https"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags = ["${local.project_name}-allow-https"]
}

resource "google_compute_firewall" "allow-other" {
  name    = "${local.project_name}-allow-other"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["3000-3010"]
  }

  source_ranges = concat(
    var.monitor_ip,
  )

  target_tags = ["${local.project_name}-allow-other"]
}

resource "google_compute_firewall" "allow-monitor" {
  name    = "${local.project_name}-allow-monitor"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["9100","9256","9090","9093"]
  }

  source_ranges = concat(
    var.monitor_ip,
  )
}