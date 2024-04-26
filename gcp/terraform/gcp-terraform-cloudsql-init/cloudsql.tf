resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-for-cloudsql"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = "172.16.3.0"
  prefix_length = 24
  network       = google_compute_network.vpc_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "instance" {
  name             = "${local.project_name}"
  region           = "asia-east1"
  database_version = "MYSQL_8_0"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-custom-2-8192"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc_network.id
      enable_private_path_for_google_cloud_services = true
    }

    database_flags {
      name  = "event_scheduler"
      value = "on"
    }
    database_flags {
      name  = "sql_mode"
      value = "STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
    }

    insights_config {
      query_insights_enabled  = false
      query_plans_per_minute  = 0
      query_string_length     = 2048
      record_application_tags = false
      record_client_address   = false
    }

    maintenance_window {
      day  = 7
      hour = 0
    }

    availability_type = "REGIONAL"
    disk_autoresize   = true
    disk_size         = 50

    user_labels = {
      "${local.project_name}" = "${local.project_name}"
    }

    backup_configuration {
      enabled            = true
      start_time         = "03:00"
      binary_log_enabled = true
      location           = "asia"
    }
  }
}

resource "google_sql_user" "test1" {
  name     = "test"
  instance = google_sql_database_instance.instance.name
  password = "00000000"
}
