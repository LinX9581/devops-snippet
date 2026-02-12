# # main.tf

# # 配置 Google Cloud 提供者
# provider "google" {
#   project = var.project_id
#   region  = var.region
# }

# # 創建 Secret Manager 秘密
# resource "google_secret_manager_secret" "env_vars" {
#   for_each = var.env_vars

#   secret_id = each.key

#   replication {
#     automatic = true
#   }
# }

# # 添加秘密版本
# resource "google_secret_manager_secret_version" "env_vars" {
#   for_each = var.env_vars

#   secret      = google_secret_manager_secret.env_vars[each.key].id
#   secret_data = each.value
# }

# # 部署 Cloud Run 服務
# resource "google_cloud_run_service" "default" {
#   name     = var.service_name
#   location = var.region

#   template {
#     spec {
#       containers {
#         image = var.container_image
        
#         resources {
#           limits = {
#             cpu    = "1"
#             memory = "512Mi"
#           }
#         }

#         dynamic "env" {
#           for_each = google_secret_manager_secret.env_vars
#           content {
#             name = env.key
#             value_from {
#               secret_key_ref {
#                 name = env.value.secret_id
#                 key  = "latest"
#               }
#             }
#           }
#         }
#       }
#     }
#   }

#   traffic {
#     percent         = 100
#     latest_revision = true
#   }
# }

# # 設置 Cloud Run 服務的 IAM 策略以允許未認證的訪問
# resource "google_cloud_run_service_iam_member" "allUsers" {
#   service  = google_cloud_run_service.default.name
#   location = google_cloud_run_service.default.location
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }

# # 輸出 Cloud Run 服務 URL
# output "service_url" {
#   value = google_cloud_run_service.default.status[0].url
# }