
variable "project_name" {
    type = string
}

locals {
  project_name = var.project_name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"
}