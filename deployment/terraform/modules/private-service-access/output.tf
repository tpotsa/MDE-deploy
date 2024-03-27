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

output "mde_config_manager_global_address" {
  value       = var.mde_data_store == "sql" ? google_compute_global_address.mde_config_manager_private_ip_address[0].address: ""
  description = "Address for the global config-manager IP if the mde_data_store variable is equal to 'sql'."
}

output "mde_config_manager_global_address_name" {
  value       = var.mde_data_store == "sql" ? google_compute_global_address.mde_config_manager_private_ip_address[0].name : ""
  description = "Name for the global config-manager IP if the mde_data_store variable is equal to 'sql'."
}