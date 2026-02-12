variable "project_id" {}
variable "project_name" {}
variable "network_name" {}
variable "subnets" {
  type = map(object({
    name = string
    cidr = string
  }))
  description = "Map of subnet names and CIDR ranges"
}
variable "network_region" {}
variable "firewall_name" {}
variable "firewall_monitor_ips" { type = list(string) }

variable "instances" {
  type = map(object({
    name       = string
    type       = string
    subnetwork = string
    tags       = list(string)
    zone       = string
    metadata   = map(string)
    boot_disk_size = number
    boot_disk_type = string
  }))
  description = "Map of instances with their configurations"
}

locals {
  project = {
    id   = var.project_id
    name = var.project_name
  }
  
  network = {
    name   = var.network_name
    region = var.network_region
    subnets = var.subnets
  }
  
  firewall = {
    name = var.firewall_name
    monitor_ips = var.firewall_monitor_ips
  }
}