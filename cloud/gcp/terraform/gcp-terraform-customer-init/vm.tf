resource "google_compute_address" "instances" {
  for_each = var.instances
  name     = each.value.name
  region   = local.network.region
}

resource "google_compute_instance" "instances" {
  for_each     = var.instances
  name         = each.value.name
  machine_type = each.value.type
  zone         = each.value.zone

  tags = each.value.tags

  boot_disk {
    initialize_params {
      size  = each.value.boot_disk_size
      image = "ubuntu-2204-lts"
      type  = each.value.boot_disk_type
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnets[each.value.subnetwork].self_link
    access_config {
      network_tier = "PREMIUM"
      nat_ip       = google_compute_address.instances[each.key].address
    }
  }

  metadata = each.value.metadata

  service_account {
    email  = "${local.project.name}-gce@${local.project.id}.iam.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  
  labels = {
    "${each.value.name}" = each.value.name
  }
}