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

locals {
  secret_value = {
    oauth-client-id                       = var.mde_secret_oauth_client_id
    oauth-client-secret                   = var.mde_secret_oauth_client_secret
    cloudsql-root-password                = var.mde_secret_cloudsql-root-password
    cloudsql-config-manager-root-password = local.config_manager_cloudsql_default_password
  }
}
resource "google_secret_manager_secret" "mde_secrets" {
  for_each  = var.mde_secrets
  secret_id = each.value
  replication {
    automatic = true
  }
  labels = var.mde_deployment_labels
}
resource "google_secret_manager_secret_version" "mde_secrets_value" {
  for_each    = var.mde_secrets
  secret      = google_secret_manager_secret.mde_secrets[each.value].id
  secret_data = local.secret_value[each.value]
}