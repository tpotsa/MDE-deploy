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

variable "mde_project_id" {
  description = "Environment project id"
}

//External Variables
variable "mde_deployment_labels" {
  type = map(string)
  default     = {goog-packaged-solution = "mfg-mde"}
}

// Network Section
variable "mde_network" {
  description = "Custom Virtual Private Network."
  default     = "mde-private-network"
}

variable "mde_data_lake_subnet_name" {
  description = "Subnet used for all of the data-lake workflows and the GKE cluster."
  default     = "mde-subnet"
}
variable "mde_data_lake_subnet_cidr" {
  default = "10.150.0.0/20"
}

variable "mde_private_services_subnet_name" {
  description = "Subnet for the private service connection to access the managed services such as CloudSQL over a private network."
  default     = "mde-private-network-ip-range"
}
variable "mde_private_services_subnet_cidr" {
  default = "10.170.0.0/20"
}

variable "mde_proxy_only_subnet_name" {
  description = "Will be used for the internal HTTP(S) Load Balancer."
  default     = "proxy-only-subnet"
}
variable "mde_proxy_only_subnet_cidr" {
  default = "10.100.0.0/20"
}

variable "mde_firewall_rule_health_check_cidr" {
  type    = set(string)
  default = ["130.211.0.0/22", "35.191.0.0/16"]
}

//DNS Zone
variable "mde_dns_zone_name" {
  type    = string
  default = "mde-private-zone"
}
