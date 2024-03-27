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

resource "google_dataflow_flex_template_job" "bigtable-writer-dataflow-flex-job" {
  count    = var.mde_size_details[var.mde_size].dataflow_btwriter_enabled? 1 : 0
  provider = google-beta
  name     = "bigtable-writer-dataflow-flex-job"

  labels                  = var.mde_deployment_labels
  machine_type            = var.mde_size_details[var.mde_size].dataflow_btwriter_machine
  project                 = var.mde_project_id
  region                  = var.mde_region
  on_delete               = "cancel"
  container_spec_gcs_path = "${var.mde_dataflow_flex_template_bucket}/${var.mde_version}/${var.mde_dataflow_flex_template_btwriter}"
  staging_location        = "gs://${var.mde_project_id}-staging/btwriter"
  temp_location           = "gs://${var.mde_project_id}-temp/btwriter"
  subnetwork              = var.mde_subnet_self_link
  service_account_email   = var.mde_dataflow_sa
  enable_streaming_engine = false
  #max_workers             = var.mde_size_details[var.mde_size].dataflow_btwriter_maxworkers
  depends_on              = [
    google_project_iam_member.mde_dataflow_sa_binding,
    helm_release.mde_fed_api, google_service_account_iam_policy.mde_bigtable_dfsink_sa_WorkloadIdentityAUPolicy
  ]

  parameters = {
    inputSubscription        = "projects/${var.mde_project_id}/subscriptions/bigtable-writer-subscription",
    operationsTopic          = "projects/${var.mde_project_id}/topics/mde-system-tables",
    bigTableInstanceId       = var.mde_bigtable_name,
    bigTableProjectId        = var.mde_project_id,
    bigTableDefaultTableId   = var.mde_bigtable_table_default_id,
    bigTableClusteredTableId = var.mde_bigtable_table_clustered_id,
    configManagerHost        = google_compute_address.mde_internal_ips["config-manager"].address,
    configManagerPort        = 50051,
    maxNumWorkers            = var.mde_size_details[var.mde_size].dataflow_btwriter_maxworkers
  }
}

