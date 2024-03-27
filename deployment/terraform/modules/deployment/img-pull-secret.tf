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
  artifact_registry_sa_key   = file(var.mde_artifact_registry_sa_path)
  artifact_registry_sa_email = regex("(?P<client>\"client_email\":\\s\")(?P<sa_email>.+)\",", local.artifact_registry_sa_key)
  artifact_registry_full_url = "https://${var.mde_artifact_registry_url}/"

  dockerconfigjson_config_manager = {
    "auths" = {
      (local.artifact_registry_full_url) = {
        email    = local.artifact_registry_sa_email["sa_email"]
        username = "_json_key"
        password = local.artifact_registry_sa_key
      }
    }
  }
}

resource "kubernetes_secret" "mde_image_pull_secret" {
  for_each = var.mde_container_namespace_names
  metadata {
    name      = format("%s-%s", var.mde_k8s_pull_secret, each.value)
    namespace = each.value
  }
  data = {
    ".dockerconfigjson" = jsonencode(local.dockerconfigjson_config_manager)
  }
  type       = "kubernetes.io/dockerconfigjson"
  depends_on = [kubernetes_namespace.mde_container_namespace]
}
