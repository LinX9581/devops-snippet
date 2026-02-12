terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }

  required_version = ">= 1.2.0"
}

provider "google" {
  project = local.project.id
  region  = local.network.region
  zone    = "${local.network.region}-b"
}