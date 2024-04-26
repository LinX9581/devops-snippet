variable "project_id" {
    type = string
}

provider "google" {
  project = local.project_id
  region  = "asia-east1"
  zone    = "asia-east1-b"
}