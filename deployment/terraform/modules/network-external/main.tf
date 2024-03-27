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

data "google_compute_network" "vpc_network" {
  name          = "mde-private-network"
}

data "google_compute_subnetwork" "mde_data_lake_subnet" {
  name          = "mde-subnet"
}

resource "google_compute_subnetwork" "mde_private_services_subnet" {
  name          = var.mde_private_services_subnet_name
  ip_cidr_range = var.mde_private_services_subnet_cidr
  network       = data.google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "mde_proxy_only_subnet" {
  provider      = google-beta
  name          = var.mde_proxy_only_subnet_name
  ip_cidr_range = var.mde_proxy_only_subnet_cidr
     network                  = data.google_compute_network.vpc_network.name 
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  depends_on    = [data.google_compute_network.vpc_network]
}

// Firewall Rules
resource "google_compute_firewall" "mde_private_health_check" {
  name        = format("%s-%s", var.mde_network, "allow-health-check")
  description = "Will enables the compute instance and GKE endpoints health check service."
     network                  = data.google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
  }
  source_ranges = var.mde_firewall_rule_health_check_cidr
  target_tags   = ["load-balanced-backend"]
  depends_on    = [data.google_compute_network.vpc_network]
}

resource "google_compute_firewall" "mde_private_proxy" {
  name        = format("%s-%s", var.mde_network, "allow-proxies")
  description = "Will enable the internal HTTP load balancer proxies traffic to the backend services."
  network     = data.google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "4242"]
  }
  source_ranges = [var.mde_proxy_only_subnet_cidr]
  depends_on    = [data.google_compute_network.vpc_network]
}

// DNS Zone
resource "google_dns_managed_zone" "mde_dns_zone" {
  dns_name    = "mde.cloud.google.com."
  name        = var.mde_dns_zone_name
  visibility  = "private"
  description = "Smart Factory Platform private zone for storing the services IP information"
  labels      = var.mde_deployment_labels
  private_visibility_config {
    networks {
      network_url = "https://www.googleapis.com/compute/v1/projects/${var.mde_project_id}/global/networks/mde-private-network"
      
    }
  }
  depends_on = [data.google_compute_network.vpc_network]
}