variable "project_id" {
    type = string
}

locals {
  project_id = var.project_id
}

provider "google" {
  credentials = file("/terra/terra.json")
  project = local.project_id
  region  = "us-central1"
  zone    = "us-central1-b"
}