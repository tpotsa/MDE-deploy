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
  configurationmanager_template_vars = {
    mde_project_id                                    = var.mde_project_id
    mde_bigquery_project_id                           = var.mde_bigquery_project_id
    mde_region                                        = var.mde_region
    mde_data_store                                    = var.mde_data_store
    mde_container_registry_project_id                 = var.mde_container_registry_project_id
    mde_container_registry_subpath                    = var.mde_container_registry_subpath
    mde_artifact_registry_url                         = var.mde_artifact_registry_url
    mde_deployment_config_manager_container_image_tag = var.mde_deployment_config_manager_container_image_tag
    mde_bigtable_instance                             = var.mde_bigtable_name
    mde_bigquery_instance                             = var.mde_bigquery_name
    mde_cloudsql_instance                             = var.mde_cloudsql_name

    mde_api_internal_ip      = google_compute_address.mde_internal_ips["api"].address
    mde_api_internal_ip_name = google_compute_address.mde_internal_ips["api"].name
    mde_api_external_ip      = google_compute_address.mde_external_ips["api-external"].address
    mde_api_external_ip_name = google_compute_address.mde_external_ips["api-external"].name

    mde_config_manager_internal_ip      = google_compute_address.mde_internal_ips["config-manager"].address
    mde_config_manager_internal_ip_name = google_compute_address.mde_internal_ips["config-manager"].name

    mde_image_pull_secret_name   = format("%s-%s", var.mde_k8s_pull_secret, kubernetes_namespace.mde_container_namespace.metadata[0].name)
    mde_namespace                = kubernetes_namespace.mde_container_namespace.metadata[0].name
    replica_count                = var.mde_size_details[var.mde_size].configurationmanager_replicas
    mde_deployment_node_selector = var.mde_size_details[var.mde_size].mde_deployment_node_selector

    mde_deployment_namespace            = kubernetes_namespace.mde_container_namespace.metadata[0].name
    mde_deployment_redis_host_primary   = var.mde_cache_host
    mde_deployment_redis_host_port      = var.mde_cache_port
    mde_deployment_redis_host_secondary = var.mde_cache_readendpoint_ip
    mde_deployment_redis_authToken      = var.mde_cache_authString

    mde_deployment_gateway_externalIPName            = var.mde_deployment_gateway_externalIPName
    mde_deployment_gateway_externalDevelopmentIPName = var.mde_deployment_gateway_externalDevelopmentIPName
    mde_deployment_gateway_domainName                = var.mde_deployment_gateway_domainName
  }
  configurationmanager = {
    name   = "configuration-manager"
    path   = format("%s/%s", var.mde_helm_configurationmanager_chart_path, "configuration-manager/")
    values = format("%s/%s", var.mde_helm_configurationmanager_chart_path, "configuration-manager/values.yaml")
  }
}


// Helm chart deployment for the configurationmanager
resource "helm_release" "mde_configuration_nmanager" {
  chart     = lookup(local.configurationmanager, "path", "")
  name      = lookup(local.configurationmanager, "name", "")
  namespace = kubernetes_namespace.mde_container_namespace.metadata[0].name
  values    = [
    templatefile(lookup(local.configurationmanager, "values", ""), local.configurationmanager_template_vars)
  ]
  wait             = false
  timeout          = 900
  disable_webhooks = true
  depends_on       = [
    google_service_account_iam_binding.mde_configuration_manager_workload_identity_binding,
    google_compute_address.mde_internal_ips,
    google_compute_address.mde_external_ips,
    kubernetes_secret.mde_image_pull_secret,
    kubernetes_cluster_role_binding_v1.mde_gke_custom_metrics_sa_binding,
    helm_release.custom_metrics
  ]
}
