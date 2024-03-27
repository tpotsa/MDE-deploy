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

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_storage_bucket" "mde_buckets" {
  for_each      = var.mde_buckets_name
  name          = "${var.mde_project_id}-${each.value}"
  location      = var.mde_region
  storage_class = "REGIONAL"
  force_destroy = true
  labels        = var.mde_deployment_labels

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_pubsub_topic_iam_binding" "binding" {
  topic    = google_pubsub_topic.mde_pubsub_change.id
  role     = "roles/pubsub.publisher"
  members  = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

resource "google_storage_notification" "bucket_notification" {
  for_each       = toset(compact([for bucket in var.mde_buckets_name : bucket == "batch-ingestion" ? bucket : ""]))
  bucket         = google_storage_bucket.mde_buckets[each.value].name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.mde_pubsub_change.id
  event_types    = ["OBJECT_FINALIZE"]
  depends_on     = [google_pubsub_topic_iam_binding.binding]
}