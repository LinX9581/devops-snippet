variable "project_id" {
    type = string
}
variable "project_json_path" {
    type = string
}

locals {
  project_id = var.project_id
}

locals {
  project_json_path = var.project_json_path
}

provider "google" {
  credentials = file("${local.project_json_path}")
  project = local.project_id
  region  = "asia-east1"
  zone    = "asia-east1-b"
}