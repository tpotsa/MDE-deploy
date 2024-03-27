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

locals {
  mde_reserved_peering_ranges = [
    var.mde_data_store == "sql" ? google_compute_global_address.mde_config_manager_private_ip_address[0].name : ""
  ]
}

data "google_compute_network" "mde_custom_network" {
  name    = var.mde_network_name
  project = var.mde_project_id
}

resource "google_compute_global_address" "mde_config_manager_private_ip_address" {
  count         = var.mde_data_store == "sql" ? 1 : 0
  provider      = google-beta
  name          = "private-ip-address-config-manager"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.mde_custom_network.name
  labels        = var.mde_deployment_labels
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = length(compact(local.mde_reserved_peering_ranges)) == 0 ? 0 : 1
  network                 = data.google_compute_network.mde_custom_network.name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = compact(local.mde_reserved_peering_ranges)
}