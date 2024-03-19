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
  project = "test"
  region  = "asia-east1"
  zone    = "asia-east1-b"
}