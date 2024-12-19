
resource "google_service_account" "gce_service_account" {
  account_id   = "${local.project.name}-gce"
  display_name = "${local.project.name} GCE Service Account"
  project      = local.project.id
}

resource "google_project_iam_member" "gce_logs_writer" {
  project = local.project.id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gce_service_account.email}"
}

resource "google_project_iam_member" "gce_monitoring_metric_writer" {
  project = local.project.id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gce_service_account.email}"
}