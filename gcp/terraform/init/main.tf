variable "project_id" {
    type = string
}

locals {
  project_id = var.project_id
}

provider "google" {
  project = local.project_id
  region  = "asia-east1"
  zone    = "asia-east1-b"
}