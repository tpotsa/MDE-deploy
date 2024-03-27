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
  mdeui_template_vars = {
    mde_project_id                    = var.mde_project_id
    mde_container_registry_project_id = var.mde_container_registry_project_id
    mde_container_registry_subpath    = "imgs"  #var.mde_container_registry_subpath
    mde_artifact_registry_url         = var.mde_artifact_registry_url
    mde_image_pull_secret_name        = format("%s-%s", var.mde_k8s_pull_secret, kubernetes_namespace.mde_container_namespace.metadata[0].name)
    replica_count                     = var.mde_size_details[var.mde_size].mdeui_replicas
    mde_deployment_node_selector      = var.mde_size_details[var.mde_size].mde_deployment_node_selector

    mde_deployment_namespace            = kubernetes_namespace.mde_container_namespace.metadata[0].name
    mde_deployment_redis_host_primary   = var.mde_cache_host
    mde_deployment_redis_host_port      = var.mde_cache_port
    mde_deployment_redis_host_secondary = var.mde_cache_readendpoint_ip
    mde_deployment_redis_authToken      = var.mde_cache_authString

    mde_deployment_mdeui_ext_http_lb_enabled   = var.mde_ui_ext_http_lb.enabled
    mde_deployment_mdeui_ext_http_lb_domain    = var.mde_ui_ext_http_lb.domain
    mde_deployment_mdeui_ext_http_lb_static_ip = var.mde_ui_ext_http_lb_static_ip

    mde_deployment_mdeui_int_http_lb_enabled   = var.mde_ui_int_http_lb.enabled
    mde_deployment_mdeui_int_http_lb_cert_name = var.mde_ui_int_http_lb.cert_name
    mde_deployment_mdeui_int_http_lb_static_ip = var.mde_ui_int_http_lb_static_ip != "" ? var.mde_ui_int_http_lb_static_ip : google_compute_address.mde_internal_ips["mde-ui"].name


    mde_deployment_gateway_externalDevelopmentIPName = var.mde_deployment_gateway_externalDevelopmentIPName
    mde_deployment_gateway_domainName                = var.mde_deployment_gateway_domainName

    mde_deployment_mdeui_config_server_host = var.mde_deployment_mdeui_config_server_host != null ? var.mde_deployment_mdeui_config_server_host : google_compute_address.mde_internal_ips["api"].address
    mde_deployment_mdeui_config_server_port = var.mde_deployment_mdeui_config_server_port

    mde_deployment_mdeui_container_tag = var.mde_deployment_mdeui_container_tag
  }
  mdeui = {
    name   = "mde-ui"
    labels = ""
    path   = format("%s/%s", var.mde_helm_mdeui_chart_path, "mde-ui/")
    values = format("%s/%s", var.mde_helm_mdeui_chart_path, "mde-ui/values.yaml")
  }
}
resource "helm_release" "mde_mdeui" {
  count     = var.mde_ui_enabled? 1 : 0
  chart     = lookup(local.mdeui, "path", "")
  name      = lookup(local.mdeui, "name", "")
  namespace = kubernetes_namespace.mde_container_namespace.metadata[0].name
  values    = [
    templatefile(lookup(local.mdeui, "values", ""), local.mdeui_template_vars)
  ]
  wait             = false
  timeout          = 900
  disable_webhooks = true
  depends_on       = [
    google_service_account_iam_binding.mde_ui_workload_identity_binding,
    google_storage_bucket.mde_workflow_bucket,
    kubernetes_secret.mde_image_pull_secret
  ]
}
