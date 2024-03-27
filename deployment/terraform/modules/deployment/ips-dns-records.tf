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

// IPs
resource "google_compute_address" "mde_internal_ips" {
  provider     = google-beta
  for_each     = { for ip in var.mde_internal_ips : ip.name => ip }
  name         = each.value.name
  address_type = "INTERNAL"
  description  = each.value.description
  subnetwork   = var.mde_deployment_subnet_name
  labels       = var.mde_deployment_labels
}

resource "google_compute_address" "mde_external_ips" {
  provider     = google-beta
  for_each     = { for ip in var.mde_external_ips : ip.name => ip }
  name         = each.value.name
  address_type = "EXTERNAL"
  description  = each.value.description
  labels       = var.mde_deployment_labels
}

// DNS Zone Records
resource "google_dns_record_set" "mde_dns_A_records" {
  for_each     = { for ip in var.mde_internal_ips : ip.name => ip }
  managed_zone = var.mde_dns_zone_name
  name         = each.value.dns
  rrdatas      = [google_compute_address.mde_internal_ips[each.value.name].address]
  ttl          = 300
  type         = "A"
}