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
  federation_api_template_vars = {
    mde_deployment_fedapi_container_image_tag = var.mde_deployment_fedapi_container_image_tag
    mde_project_id                            = var.mde_project_id
    mde_bigquery_project_id                   = var.mde_bigquery_project_id
    mde_static_ip                             = google_compute_address.mde_internal_ips["federation-api"].address
    mde_static_name                           = google_compute_address.mde_internal_ips["federation-api"].name
    mde_external_static_ip                    = google_compute_address.mde_external_ips["federation-api-external"].address
    mde_container_registry_project_id         = var.mde_container_registry_project_id
    mde_container_registry_subpath            = var.mde_container_registry_subpath
    mde_artifact_registry_url                 = var.mde_artifact_registry_url
    mde_image_pull_secret_name                = format("%s-%s", var.mde_k8s_pull_secret, kubernetes_namespace.mde_container_namespace.metadata[0].name)
    mde_federation_api_sa_id                  = var.mde_federation_api_sa_id
    mde_deployment_namespace                  = kubernetes_namespace.mde_container_namespace.metadata[0].name
    mde_bigtable_project_id                   = var.mde_project_id
    mde_bigtable_name                         = var.mde_bigtable_name
    mde_deployment_node_selector              = var.mde_size_details[var.mde_size].mde_deployment_node_selector
  }
  federation_api = {
    name   = "fed-api"
    path   = format("%s/%s", var.mde_helm_federation_api_chart_path, "fed-api/")
    values = format("%s/%s", var.mde_helm_federation_api_chart_path, "fed-api/values.yaml")
  }
}
resource "helm_release" "mde_fed_api" {
  chart     = lookup(local.federation_api, "path", "")
  name      = lookup(local.federation_api, "name", "")
  namespace = kubernetes_namespace.mde_container_namespace.metadata[0].name
  values    = [
    templatefile(lookup(local.federation_api, "values", ""), local.federation_api_template_vars)
  ]
  wait             = false
  timeout          = 900
  disable_webhooks = true
  depends_on       = [
    google_service_account_iam_binding.mde_federation_api_workload_identity_binding,
    kubernetes_secret.mde_image_pull_secret,
    helm_release.custom_metrics
  ]
}