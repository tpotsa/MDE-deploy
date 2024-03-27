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

// mde Project definitions
variable "mde_project_id" {
  description = "Environment project id"
}
variable "mde_bigquery_project_id" {
  description = "Environment BigQuery project id"
}

variable "mde_region" {
  description = "Default region where all services are being provisioned."
  default     = "europe-west1"
}
variable "mde_zone" {
  description = "Default zone where all services are being provisioned."
  default     = "europe-west1-c"
}
variable "mde_deployment_labels" {
  type    = map(string)
  default = { goog-packaged-solution = "mfg-mde" }
}
variable "mde_gke_labels" {
  description = "GKE allows only lowercase letters ([a-z]), numeric characters ([0-9]), underscores (_) and dashes (-). International characters are allowed too."
  type        = map(string)
  default     = { goog-packaged-solution = "mfg-mde" }
}

// Credentials definitions
variable "mde_tf_sa" {
  description = "The name of the service account that terraform will use to run the scripts"
}
variable "mde_dataflow_sa" {
  description = "The name of the service account that Dataflow will use to start and execute the flex jobs"
}
variable "mde_artifact_registry_sa_path" {
  description = "Full path for the service account with permissions on the Artifact Registry."
}
variable "mde_container_registry_project_id" {
  type    = string
  default = "imde-backbone"
}
variable "mde_artifact_registry_url" {
  description = "Artifact Registry that holds the container images."
  default     = "europe-docker.pkg.dev"
}
variable "mde_container_registry_subpath" {
  description = "Sub path for the images within Artifact Registry."
  default     = "imgs"
}

// Deployment Parameters
// for Network module
variable "mde_network_enabled" {
  type        = bool
  default     = true
  description = "To determine if the cloud solution will provision the vpc, subnet, and dns services needed."
}
// for Infrastructure module
variable "mde_infrastructure_enabled" {
  type        = bool
  default     = true
  description = "To determine if the cloud solution will provision all the Infrastructure needed."
}
variable "mde_data_store" {
  type        = string
  default     = "sql"
  description = "Indicates if the solution will use BigTable Instance(bt) or a Postgres CloudSQL (sql) as backend for the Configuration Manager"
  validation {
    condition     = contains(["sql"], var.mde_data_store)
    error_message = "Valid values for data store variable are: sql or bt."
  }
}

variable "mde_bt_enabled" {
  type        = bool
  description = "Weather to enable BigTable instances"
  default     = true
}

variable "mde_ui_enabled" {
  type = bool
  description = "To determine if the MDE UI should be deployed as GKE workload."
  default = true
}

variable "mde_ui_ext_http_lb_static_ip" {
  type = string
  description = "Static IP of the external HTTP Load Balancer"
  default = ""
}

variable "mde_ui_ext_http_lb" {
  type = object({
    enabled = bool
    domain = string

  })
  default = {
    enabled = false
    domain = ""
  }
  description = <<EOT
      {
        "enabled":"To determine if an external HTTP Load Balancer should be deployed with MDE UI",
        "domain":"Domain name of Google managed SSL certificate associated with the external HTTP Load Balancer",
      }
  EOT
}

variable "mde_ui_int_http_lb_static_ip" {
  type = string
  description = "Static IP of the internal HTTP Load Balancer"
  default = ""
}

variable "mde_ui_int_http_lb" {
  type = object({
    enabled = bool
    cert_name = string
  })
  default = {
    enabled = false
    cert_name = ""
  }
  description = <<EOT
      {
        "enabled":"To determine if an internal HTTP Load Balancer should be deployed with MDE UI",
        "cert_name":"The self-managed SSL certificate name associated with the internal HTTP Load Balancer",
      }
  EOT
}

variable "mde_storage_config_multi-cluster" {
  type        = bool
  description = "To enable multiple cluster deployments for the Bigtable instances."
  default     = true
}

variable "mde_cloudsql_enabled" {
  type        = bool
  description = "To determine if the cloud solution will include a CloudSQL instance"
  default     = false
}
// for deployment module
variable "mde_grafana_enabled" {
  type        = bool
  description = "To determine if the cloud solution will include a highly available Grafana instance."
  default     = false
}
// for api-services module
variable "mde_disable_api_on_destroy" {
  type        = bool
  description = "To determine if the infrastructure will disable on destroy phase the gcloud apis that it enables."
  default     = false
}

variable "mde_dev_mode" {
  type        = bool
  description = "To determine if the cloud solution will run in development mode."
  default     = false
}

// Network
variable "mde_network_name" {
  type        = string
  description = "Custom Virtual Private Network Name."
  default     = ""
}
variable "mde_network_project_id" {
  description = "Environment Network project id"
  default     = ""
}
/*variable "mde_deployment_subnet_project_id" {
  type        = string
  description = "Project Id of the subnetwork where the workflows will be deployed."
  default     = ""
}*/
variable "mde_deployment_subnet_name" {
  type        = string
  description = "Subnetwork name where the workflows will be deployed."
  default     = ""
}
variable "mde_dns_zone_name" {
  type    = string
  default = ""
}
variable "mde_internal_ips" {
  type = set(object({
    name        = string
    description = string
    dns         = string
  }))
  default = [
    {
      name        = "config-manager"
      description = "Used by the configuration management API"
      dns         = "config-manager.mde.cloud.google.com."
    },
    {
      name        = "federation-api"
      description = "Used by the time-series API"
      dns         = "federation-api.mde.cloud.google.com."
    },
    {
      name        = "api"
      description = "Used for communication with API service"
      dns         = "api.mde.cloud.google.com."
    },
    {
      name        = "ui"
      description = "Used for manufacturing connect edge"
      dns         = "ui.mde.cloud.google.com."
    }
  ]
}

// Storage
variable "mde_bigtable_name" {
  type    = string
  default = ""
  #default = "timeseries-config-storage"
}
variable "mde_bigquery_name" {
  type    = string
  default = ""
}
variable "mde_bigquery_location" {
  type    = string
  default = "EU"
}

variable "mde_cloudsql_name" {
  type        = string
  default     = ""
  description = "Name of the CloudSQL Instance"
}
variable "mde_cloudsql_username" {
  type        = string
  description = "Name of the CloudSQL Username"
  default     = ""
}

// Container
variable "mde_gke_name" {
  type    = string
  default = ""
}
variable "mde_gke_location" {
  type    = string
  default = ""
}

// Deployment Charts
#variable "mde_helm_config_manager_chart_path" {
#  type    = string
#  default = "../charts"
#}
#variable "mde_helm_timeseries_chart_path" {
#  type    = string
#  default = "../charts"
#}
#variable "mde_helm_workflows_deployer_chart_path" {
#  type    = string
#  default = "../charts"
#}
#variable "mde_helm_federation_api_chart_path" {
#  type    = string
#  default = "../charts"
#}



variable "mde_helm_apiservices_mdegateway_chart_path" {
  type    = string
  default = "../charts"
}
variable "mde_helm_federation_api_chart_path" {
  type    = string
  default = "../charts"
}
variable "mde_helm_configurationmanager_chart_path" {
  type    = string
  default = "../charts"
}
variable "mde_helm_messagemapper_chart_path" {
  type    = string
  default = "../charts"
}
variable "mde_helm_metadatamanager_chart_path" {
  type    = string
  default = "../charts"
}
variable "mde_helm_pubsub_sink_chart_path" {
  type    = string
  default = "../charts"
}
variable "mde_helm_bigquerysink_chart_path" {
  type    = string
  default = "../charts"
}
variable "mde_helm_mdesimulator_chart_path" {
  type    = string
  default = "../charts"
}

variable "mde_helm_mdeui_chart_path" {
  type    = string
  default = "../charts"
}

variable "mde_helm_bigquery_sink_chart_path" {
  type    = string
  default = "../charts"
}
variable "mde_helm_mde_simulator_chart_path" {
  type    = string
  default = "../charts"
}

variable "mde_deployment_gateway_domainName" {
  type    = string
  default = "local"
}
variable "mde_helm_custom_metrics_chart_path" {
  type    = string
  default = "../charts"
}

// Secret Manager
variable "mde_secret_oauth_client_id" {
  type      = string
  sensitive = true
  default   = "<empty>"
}
variable "mde_secret_oauth_client_secret" {
  type      = string
  sensitive = true
  default   = "<empty>"
}
variable "mde_secret_cloudsql-root-password" {
  type      = string
  sensitive = true
  default   = "<empty>"
}
variable "mde_secret_cloudsql_config_manager-root-password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "mde_dataflow_flex_template_bucket" {
  type    = string
  default = "gs://mde-dataflow-templates"
}


variable "mde_size" {
  type        = string
  default     = "Small"
  description = "Sizing for MDE, should be: Small, Medium, Pilot, Large. Please refer to the documentation for further details."
  validation {
    condition     = contains(["Small", "Medium", "Pilot", "Large"], var.mde_size)
    error_message = "Valid options for mde_size are: Small, Medium, Pilot, Large."
  }
}

variable "mde_version" {
  type    = string
  default = "1.3.5"
}

variable "mde_artifacts_release_tag" {
  type    = string
  default = "7a994ee"
}

