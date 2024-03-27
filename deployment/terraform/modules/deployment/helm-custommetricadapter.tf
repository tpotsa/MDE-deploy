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
  custom_metrics_template_vars = {
    mde_project_id                      = var.mde_project_id
    custom_metrics_container_url        = "gcr.io/gke-release/custom-metrics-stackdriver-adapter"
    custom_metrics_container_tag        = var.mde_deployment_custom_metricsr_image_tag
    custom_metrics_container_pullPolicy = "IfNotPresent"
  }
  custom_metrics = {
    name   = "custom-metrics"
    labels = ""
    path   = format("%s/%s", var.mde_helm_custom_metrics_chart_path, "custom-metrics/")
    values = format("%s/%s", var.mde_helm_custom_metrics_chart_path, "custom-metrics/values.yaml")
  }
}

resource "helm_release" "custom_metrics" {
  chart     = lookup(local.custom_metrics, "path", "")
  name      = lookup(local.custom_metrics, "name", "")
  namespace = kubernetes_namespace.mde_container_namespace_custom_metrics.metadata[0].name
  values    = [
    templatefile(lookup(local.custom_metrics, "values", ""), local.custom_metrics_template_vars)
  ]
  wait             = false
  timeout          = 900
  disable_webhooks = true
  depends_on       = [
    google_service_account_iam_binding.mde_gke_custom_metrics_workload_identity_binding,
    kubernetes_secret.mde_image_pull_secret,
    kubernetes_cluster_role_binding_v1.mde_gke_custom_metrics_sa_binding
  ]
}
