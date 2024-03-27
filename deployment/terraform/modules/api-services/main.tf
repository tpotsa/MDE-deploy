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

resource "google_project_service" "mde_service_api_cloudresourcemanager" {
  for_each                   = var.mde_service_apis_cloudresourcemanager
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = var.mde_disable_api_on_destroy
  timeouts {
    create = "20m"
    delete = "20m"
    read   = "10m"
  }
}
// FixMe ugly hack, but since the service api is async we must wait for gcp to enable the apis, hopefully 2 min will be enough.
resource "time_sleep" "wait_2_min_cloudresourcemanager" {
  create_duration  = "2m"
  destroy_duration = "1m"
  depends_on       = [google_project_service.mde_service_api_cloudresourcemanager]
}

resource "google_project_service" "mde_service_api" {
  for_each                   = var.mde_service_apis
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = var.mde_disable_api_on_destroy
  timeouts {
    create = "20m"
    delete = "20m"
    read   = "10m"
  }
  depends_on = [time_sleep.wait_2_min_cloudresourcemanager]
}
// FixMe ugly hack, but since the service api is async we must wait for gcp to enable the apis, hopefully 2 min will be enough.
resource "time_sleep" "wait_2_min" {
  depends_on       = [google_project_service.mde_service_api]
  create_duration  = "2m"
  destroy_duration = "1m"
}