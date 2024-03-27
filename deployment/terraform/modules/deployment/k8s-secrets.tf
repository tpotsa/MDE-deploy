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

resource "kubernetes_secret" "mde_metadata_manager_secret" {
  metadata {
    name      = var.mde_metadata_manager_secret
    namespace = kubernetes_namespace.mde_container_namespace.metadata[0].name
  }
  data = {
    "database" = "metadata-manager"
    "password" = var.mde_cloudsql_password
    "username" = var.mde_cloudsql_username
  }
  type       = "Opaque"
  depends_on = [kubernetes_namespace.mde_container_namespace]
}

resource "kubernetes_secret" "mde_configuration_manager_secret" {
  metadata {
    name      = var.mde_configuration_manager_secret
    namespace = kubernetes_namespace.mde_container_namespace.metadata[0].name
  }
  data = {
    "database" = "mde-configurations"
    "password" = var.mde_cloudsql_password
    "username" = var.mde_cloudsql_username
  }
  type       = "Opaque"
  depends_on = [kubernetes_namespace.mde_container_namespace]
}