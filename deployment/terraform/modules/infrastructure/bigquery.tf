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

resource "google_bigquery_dataset" "mde_bigquery_dataset_mde_data" {
  project                    = ""
  dataset_id                 = var.mde_bigquery_dataset_mde_data_id_name
  location                   = var.mde_bigquery_location
  labels                     = var.mde_deployment_labels
  delete_contents_on_destroy = true

  lifecycle {
    prevent_destroy = true
  }
#  depends_on = [null_resource.bigquery_tables_deletion_prevention]
}

resource "google_bigquery_dataset" "mde_bigquery_dataset_mde_dimension" {
  dataset_id                 = var.mde_bigquery_dataset_mde_dimension_id_name
  location                   = var.mde_bigquery_location
  labels                     = var.mde_deployment_labels
  delete_contents_on_destroy = true

  lifecycle {
    prevent_destroy = true
  }
  #depends_on = [null_resource.bigquery_tables_deletion_prevention]
}
resource "google_bigquery_dataset" "mde_bigquery_dataset_mde_system" {
  dataset_id                 = var.mde_bigquery_dataset_mde_system_id_name
  location                   = var.mde_bigquery_location
  labels                     = var.mde_deployment_labels
  delete_contents_on_destroy = true

  lifecycle {
    prevent_destroy = true
  }
 # depends_on = [null_resource.bigquery_tables_deletion_prevention]
}

#resource "null_resource" "bigquery_tables_deletion_prevention" {
#  provisioner "local-exec" {
#    command = "../deployment/config/prevent-bqtables-deletion.sh ${var.mde_bigquery_project_id}"
#  }
#}