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

output "mde_bigtable_instance_name" {
  value = var.mde_bt_enabled && var.mde_size_details[var.mde_size].mde_bigtable_nodes>0 ? google_bigtable_instance.mde_bigtable[0].name : "BigTable is disabled."
}

output "mde_bigquery_instance_name" {
  value = google_bigquery_dataset.mde_bigquery_dataset_mde_data.dataset_id
}

output "mde_cloudsql_instance_name" {
  value = var.mde_data_store == "sql" ? google_sql_database_instance.mde_cloudsql[0].name : ""
}

output "mde_cloudsql_instance_username" {
  value = var.mde_data_store == "sql" ? google_sql_user.root_user[0].name : ""
}
output "mde_cloudsql_instance_password" {
  value = var.mde_data_store == "sql" ? google_sql_user.root_user[0].password : ""
}

output "mde_gke_name" {
  value = google_container_cluster.mde_gke.name
}

output "mde_gke_location" {
  value = google_container_cluster.mde_gke.location
}