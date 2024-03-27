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

//External Variables
variable "mde_project_id" {
  type        = string
  description = "The project ID of the VPC network to peer. This can be a shared VPC host project."
}
variable "mde_network_name" {
  type        = string
  description = "Name of the VPC network to peer."
}
variable "mde_deployment_labels" {
  type        = map(string)
  default     = {}
  description = "The key/value labels for the IP range allocated to the peered network."
}
variable "mde_data_store" {
  type = string
  description = "To indicate if the module will provision a global address for the config-manager CloudSQL"
  default = "bt"
  validation {
    condition     = contains(["sql", "bt"], var.mde_data_store)
    error_message = "Valid values for data store variable are: sql or bt."
  }
}