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

// GKE SA
resource "google_service_account" "mde_container_sa" {
  project      = var.mde_project_id
  account_id   = var.mde_container_sa
  display_name = var.mde_container_sa
  description  = "SA for the Cluster Pods - GKE"
}
resource "google_project_iam_member" "mde_container_sa_binding" {
  for_each = var.mde_container_sa_roles
  project  = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_container_sa.email}"
  role     = each.value
}

// Cloud Build SA
data "google_project" "project" {
  project_id = var.mde_project_id
}
resource "google_project_iam_member" "mde_cloud_build_sa_binding" {
  for_each = var.mde_cloud_build_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  role     = each.value
}

// MDE Proxy SA
resource "google_service_account" "mde_proxy_sa" {
  project      = var.mde_project_id
  account_id   = var.mde_proxy_gce_sa
  display_name = var.mde_container_sa
  description  = "SA for running the GCE instance of MDE Proxy"
}

// Pubisher permission for DeadLetter & Pubsub-BigQuery-Subscription
resource "google_project_iam_member" "mde_pubsub_sa_binding" {
  for_each = var.mde_pubsub_sa_roles
  project  = var.mde_project_id
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
  role     = each.value
}