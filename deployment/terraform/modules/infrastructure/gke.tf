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

resource "google_container_cluster" "mde_gke" {
  provider = google-beta # auutoscaling profile isn't accessible in standard provider module
  name             = var.mde_container_name
  project          = var.mde_project_id
  enable_autopilot = true
  location         = var.mde_region
  network          = var.mde_network
  subnetwork       = var.mde_subnet_name
  resource_labels  = var.mde_gke_labels

  cluster_autoscaling {
    autoscaling_profile=  var.mde_size_details[var.mde_size].mde_gke_cluster_autoscalingprofile
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.mde_size_details[var.mde_size].mde_gke_cluster_cidr_pods
    services_ipv4_cidr_block = var.mde_size_details[var.mde_size].mde_gke_cluster_cidr_services
  }

//  There is a bug that makes not possible to assign a custom SA to a autopilot GKE.
//  Will keep this code here until the bug gets fixed.
//  Remove the comment will result in re-creation of the cluster with each terraform run
//  More on:
//  https://github.com/hashicorp/terraform-provider-google/issues/8918
//  https://github.com/hashicorp/terraform-provider-google/issues/9505
  /*
  node_config {
    service_account = google_service_account.mde_container_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/userinfo.email"
    ]
  }*/

  // not necessary for Autopilot mode
  #workload_identity_config {
  # workload_pool = "${var.mde_project_id}.svc.id.goog"
  #}

  lifecycle {
    ignore_changes = [node_config, dns_config]
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    //  TODO Should this range be parametrized ?
    master_ipv4_cidr_block = "10.155.0.0/28"
    master_global_access_config {
      enabled = false
    }
  }

  release_channel {
    channel = "STABLE"
  }
}

