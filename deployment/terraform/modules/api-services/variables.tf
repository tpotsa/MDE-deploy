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

// Service APIs
variable "mde_disable_api_on_destroy" {
  type        = bool
  description = "To determine if the infrastructure will disable on destroy phase the gcloud apis that it enables."
  default     = false
}
variable "mde_service_apis_cloudresourcemanager" {
  type    = set(string)
  default = ["bigquerydatatransfer.googleapis.com", "dataflow.googleapis.com", "cloudresourcemanager.googleapis.com"]
}
variable "mde_service_apis" {
  type = set(string)
  default = [
    "cloudapis.googleapis.com", "cloudbuild.googleapis.com", "container.googleapis.com",
    "containerregistry.googleapis.com", "sqladmin.googleapis.com", "bigtable.googleapis.com", "bigtableadmin.googleapis.com",
    "cloudfunctions.googleapis.com", "pubsub.googleapis.com", "logging.googleapis.com", "compute.googleapis.com",
    "iam.googleapis.com", "iamcredentials.googleapis.com", "dns.googleapis.com", "servicenetworking.googleapis.com",
    "artifactregistry.googleapis.com", "deploymentmanager.googleapis.com", "oslogin.googleapis.com",
    "sql-component.googleapis.com", "storage-component.googleapis.com", "storage.googleapis.com", "storage-api.googleapis.com",
    "cloudtrace.googleapis.com", "secretmanager.googleapis.com", "sts.googleapis.com", "servicemanagement.googleapis.com",
    "monitoring.googleapis.com", "run.googleapis.com", "bigquerystorage.googleapis.com",
    "bigquery.googleapis.com", "aiplatform.googleapis.com", "redis.googleapis.com"
  ]
}