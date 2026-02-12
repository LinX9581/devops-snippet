variable "project_id" {
    type = string
}

locals {
  project_id = var.project_id
}

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
  project = local.project_id
  region  = "asia-east1"
  zone    = "asia-east1-b"
}