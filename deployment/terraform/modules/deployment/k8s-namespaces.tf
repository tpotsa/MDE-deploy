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

#resource "kubernetes_namespace" "mde_container_namespaces" {
#  for_each = var.mde_container_namespace_names
#  metadata {
#    name = each.value
#  }
#}

resource "kubernetes_namespace" "mde_container_namespace" {
  metadata {
    name = var.mde_container_namespace
  }
  
}
resource "kubernetes_namespace" "mde_container_namespace_custom_metrics" {
  metadata {
    name = "custom-metrics"
  }
}