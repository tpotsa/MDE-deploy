/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


resource "google_redis_instance" "mde_cache" {
  name           = var.mde_cache_instance_name
  tier           = var.mde_size_details[var.mde_size].mde_redis_tier

  memory_size_gb = var.mde_size_details[var.mde_size].mde_redis_memorysize_gb
  replica_count  = var.mde_size_details[var.mde_size].mde_redis_tier == "BASIC"? 0 : var.mde_size_details[var.mde_size].mde_redis_replicacount
  region         = var.mde_region
  authorized_network = "projects/${var.mde_project_id}/global/networks/${var.mde_network}"
  connect_mode   = "PRIVATE_SERVICE_ACCESS"
  redis_version  = "REDIS_6_X"
  read_replicas_mode  = var.mde_size_details[var.mde_size].mde_redis_tier == "BASIC"? "READ_REPLICAS_DISABLED":"READ_REPLICAS_ENABLED"
  display_name   = var.mde_cache_instance_name
  labels         = var.mde_deployment_labels
}

output "mde_cache_host" {
  description = "The IP address of the instance."
  value = "${google_redis_instance.mde_cache.host}"
}
output "mde_cache_port" {
  description = "The port address of the instance."
  value = google_redis_instance.mde_cache.port
}
output "mde_cache_readendpoint_ip" {
  description = "The IP for the read address of the instance."
  value = "${google_redis_instance.mde_cache.read_endpoint}"
}
output "mde_cache_readendpoint_port" {
  description = "The port address of the instance."
  value = "${google_redis_instance.mde_cache.host}"
}
output "mde_cache_authString" {
  description = "The authentication string of the instance."
  value = "${google_redis_instance.mde_cache.auth_string}"
}
