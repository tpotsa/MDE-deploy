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

output "mde_network_name" {
  value = "mde-private-network"
}

output "mde_deployment_subnetwork_project_id" {
  value = "${var.mde_project_id}"
}

output "mde_deployment_subnetwork_name" {
  value = "mde-subnet"
}

// gcloud compute networks subnets describe mde-subnet
output "mde_deployment_subnetwork_self_link" {
  value = " https://www.googleapis.com/compute/v1/projects/${var.mde_project_id}/regions/europe-west1/subnetworks/mde-subnet" //google_compute_subnetwork.mde_data_lake_subnet.self_link
}

output "mde_dns_zone_name" {
  value = google_dns_managed_zone.mde_dns_zone.name
}