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
  metadata_manager_template_vars = {
    mde_deployment_metadatamanager_container_image_tag=var.mde_deployment_metadatamanager_container_image_tag
    mde_project_id                      = var.mde_project_id
    mde_container_registry_project_id   = var.mde_container_registry_project_id
    mde_container_registry_subpath      = var.mde_container_registry_subpath
    mde_artifact_registry_url           = var.mde_artifact_registry_url
    mde_image_pull_secret_name          = format("%s-%s", var.mde_k8s_pull_secret, kubernetes_namespace.mde_container_namespace.metadata[0].name)
    mde_bigquery_project_id             = var.mde_bigquery_project_id
    mde_region                          = var.mde_region
    mde_cloudsql_instance               = var.mde_cloudsql_name
    replica_count                       = var.mde_size_details[var.mde_size].metadata_manager_replicas
    mde_deployment_node_selector        = var.mde_size_details[var.mde_size].mde_deployment_node_selector

    mde_deployment_namespace            = kubernetes_namespace.mde_container_namespace.metadata[0].name
    mde_deployment_redis_host_primary   = var.mde_cache_host
    mde_deployment_redis_host_port      = var.mde_cache_port
    mde_deployment_redis_host_secondary = var.mde_cache_readendpoint_ip
    mde_deployment_redis_authToken      = var.mde_cache_authString

    mde_internalIPName = google_compute_address.mde_internal_ips["metadata-manager"].address
  }
  metadata_manager = {
    name   = "metadata-manager"
    labels = ""
    path   = format("%s/%s", var.mde_helm_metadatamanager_chart_path, "metadata-manager/")
    values = format("%s/%s", var.mde_helm_metadatamanager_chart_path, "metadata-manager/values.yaml")
  }
}
resource "helm_release" "mde_metadata_manager" {
  chart     = lookup(local.metadata_manager, "path", "")
  name      = lookup(local.metadata_manager, "name", "")
  namespace = kubernetes_namespace.mde_container_namespace.metadata[0].name
  values    = [
    templatefile(lookup(local.metadata_manager, "values", ""), local.metadata_manager_template_vars)
  ]
  wait             = false
  timeout          = 900
  disable_webhooks = true
  depends_on       = [
    google_service_account_iam_binding.mde_metadata_manager_workload_identity_binding,
    google_storage_bucket.mde_workflow_bucket,
    kubernetes_secret.mde_image_pull_secret,
    helm_release.custom_metrics
  ]
}
