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

// Helm chart deployment for Grafana
module "grafana" {
  count           = var.mde_grafana_enabled ? 1 : 0
  source          = "basisai/grafana/helm"
  version         = "0.2.0"
  chart_version   = "6.16.6"
  tag             = "latest"
  chart_namespace = kubernetes_namespace.mde_container_namespace.metadata[0].name
  service_type    = "LoadBalancer"
  plugins         = ["simpod-json-datasource"]
}