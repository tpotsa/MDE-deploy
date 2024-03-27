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

  pubsub_sink_template_vars = {
    mde_deployment_pubsub_sink_container_image_tag=var.mde_deployment_pubsub_sink_container_image_tag
    mde_project_id                      = var.mde_project_id
    mde_container_registry_project_id   = var.mde_container_registry_project_id
    mde_container_registry_subpath      = var.mde_container_registry_subpath
    mde_artifact_registry_url           = var.mde_artifact_registry_url
    mde_image_pull_secret_name          = format("%s-%s", var.mde_k8s_pull_secret, kubernetes_namespace.mde_container_namespace.metadata[0].name)
    mde_namespace = var.mde_container_namespace
    replica_count                       = var.mde_size_details[var.mde_size].pubsub_sink_replicas
    mde_deployment_node_selector        = var.mde_size_details[var.mde_size].mde_deployment_node_selector

    mde_deployment_namespace            = kubernetes_namespace.mde_container_namespace.metadata[0].name
    mde_deployment_redis_host_primary   = var.mde_cache_host
    mde_deployment_redis_host_port      = var.mde_cache_port
    mde_deployment_redis_host_secondary = var.mde_cache_readendpoint_ip
    mde_deployment_redis_authToken      = var.mde_cache_authString

    mde_deployment_gateway_externalIPName = var.mde_deployment_gateway_externalIPName
    mde_deployment_gateway_externalDevelopmentIPName = var.mde_deployment_gateway_externalDevelopmentIPName
    mde_deployment_gateway_domainName = var.mde_deployment_gateway_domainName
  }
  pubsub_sink = {
    name   = "pubsub-sink"
    labels = ""
    path   = format("%s/%s", var.mde_helm_pubsub_sink_chart_path, "pubsub-sink/")
    values = format("%s/%s", var.mde_helm_pubsub_sink_chart_path, "pubsub-sink/values.yaml")
  }
}
resource "helm_release" "mde_pubsub_sink" {
  chart     = lookup(local.pubsub_sink, "path", "")
  name      = lookup(local.pubsub_sink, "name", "")
  namespace = kubernetes_namespace.mde_container_namespace.metadata[0].name
  values    = [
    templatefile(lookup(local.pubsub_sink, "values", ""), local.pubsub_sink_template_vars)
  ]
  wait             = false
  timeout          = 900
  disable_webhooks = true
  depends_on       = [
    google_service_account_iam_binding.mde_pubsub_sink_workload_identity_binding,
    google_storage_bucket.mde_workflow_bucket,
    kubernetes_secret.mde_image_pull_secret,
    helm_release.custom_metrics
  ]
}
