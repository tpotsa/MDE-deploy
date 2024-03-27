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

//External Variables
variable "mde_project_id" {
  description = "Environment project id"
}
variable "mde_bigquery_project_id" {
  description = "Environment BigQuery project id"
}
variable "mde_region" {
  description = "Default region where all services are being provisioned."
}
variable "mde_tf_sa" {
  description = "The name of the service account that terraform will use to run the scripts"
  #default = "mde-tf@${PROJECTID}.iam.gserviceaccount.com"
}
variable "mde_dataflow_sa" {
  type = string
  #default = "mde-dataflow-worker@${PROJECTID}.iam.gserviceaccount.com"
}

variable "mde_dataflow_sa_roles" {
  type    = set(string)
  default = [
    "roles/dataflow.admin", "roles/dataflow.worker",
    "roles/bigquery.dataViewer", "roles/bigquery.jobUser",
    "roles/storage.objectAdmin", "roles/pubsub.editor",
    "roles/bigtable.admin", "roles/monitoring.admin", "roles/cloudtrace.admin"
  ]
}

variable "mde_dev_mode" {
  type        = bool
  description = "To determine if the cloud solution will run in development mode."
  default     = false
}
variable "mde_container_registry_project_id" {
  type    = string
  default = "imde-backbone"
}
variable "mde_bigtable_name" {
  type        = string
  description = "Name of the Big Table Instance"
}
variable "mde_bigtable_table_default_id" {
  type        = string
  description = "Name of the default BigTable Table for non clustered data"
  default     = "default-archetypes"
}
variable "mde_bigtable_table_clustered_id" {
  type        = string
  description = "Name of the default BigTable Table for clustered data"
  default     = "clustered-archetypes"
}

variable "mde_cloudsql_name" {
  type        = string
  description = "Name of the CloudSQL Instance"
}
variable "mde_cloudsql_username" {
  type        = string
  description = "Name of the CloudSQL Username"
}
variable "mde_cloudsql_password" {
  type        = string
  description = "Value for the CloudSQL Password"
}
variable "mde_bigquery_name" {
  type        = string
  description = "Name of the Big Query Instance"
}
variable "mde_helm_workflows_deployer_subnet_project_id" {
  type        = string
  description = "Project Id of the subnet where the workflows will be deployed."
}
variable "mde_deployment_subnet_name" {
  description = "Subnet used for all of the data-lake workflows and the GKE cluster."
}
variable "mde_subnet_self_link" {
  type        = string
  description = "Subnet self-link used for all of the data-lake workflows and the GKE cluster."
}

variable "mde_deployment_labels" {
  type    = map(string)
  default = { goog-packaged-solution = "mfg-mde" }
}
variable "mde_dns_zone_name" {
  type = string
}
variable "mde_grafana_enabled" {
  type        = bool
  description = "To determine if the cloud solution will include a highly available Grafana instance."
  default     = false
}
variable "mde_data_store" {
  type        = string
  description = "To indicate if the module will provision a global address for the config-manager CloudSQL"
  default     = "sql"
  validation {
    condition     = contains(["sql", "bt"], var.mde_data_store)
    error_message = "Valid values for data store variable are: sql or bt."
  }
}

// Variables related to Deployments
// IPs
variable "mde_external_ips" {
  type = set(object({
    name        = string
    description = string
  }))
  default = [
    {
      name        = "api-external"
      description = "Used by the API ui externally"
    },
    {
      name        = "federation-api-external"
      description = "Used by the federation APIs externally"
    }

  ]
}
variable "mde_internal_ips" {
  type = set(object({
    name        = string
    description = string
    dns         = string
  }))
  default = [
    {
      name        = "api"
      description = "Used as common gateway for multiple api's: config-manager, metadata-manager & federation api"
      dns         = "api.mde.cloud.google.com."
    },
    {
      name        = "config-manager"
      description = "Used by the configuration management API"
      dns         = "config-manager.mde.cloud.google.com."
    },
    {
      name        = "metadata-manager"
      description = "Used by the configuration management API"
      dns         = "metadata-manager.mde.cloud.google.com."
    },
    {
      name        = "federation-api"
      description = "Used by the federation API"
      dns         = "federation-api.mde.cloud.google.com."
    },
    {
      name        = "mde-ui"
      description = "Used by the MDE UI"
      dns         = "ui.mde.cloud.google.com."
    }
  ]
}

// Buckets
variable "mde_bigquery_bucket_name" {
  type    = set(string)
  default = ["df", "df-euw1", "gcs-ingestion"]
}

variable "mde_dataflow_flex_template_bucket" {
  type    = string
  default = "gs://mde-dataflow-templates"
}


variable "mde_dataflow_flex_template_btwriter" {
  type    = string
  default = "bigtable-writer.json"
}

variable "mde_dataflow_flex_template_gcswriter" {
  type    = string
  default = "gcs-writer.json"
}

variable "mde_dataflow_flex_template_gcsreader" {
  type    = string
  default = "gcs-reader.json"
}

variable "mde_dataflow_flex_template_eventchange" {
  type    = string
  default = "event-change.json"
}
variable "mde_dataflow_flex_template_window" {
  type    = string
  default = "window.json"
}

//K8s IAM - Service Accounts
// Config Manager
variable "mde_configuration_manager_sa_id" {
  type    = string
  default = "configuration-manager"
}
variable "mde_configuration_manager_sa_roles" {
  type    = set(string)
  default = [
    "roles/bigtable.admin", "roles/monitoring.admin", "roles/bigquery.admin",
    "roles/cloudsql.client", "roles/storage.objectAdmin", "roles/pubsub.admin",
    "roles/cloudtrace.admin", "roles/secretmanager.admin"
  ]
}


// message - mapper
variable "mde_message_mapper_sa_id" {
  type    = string
  default = "message-mapper"
}
variable "mde_message_mapper_sa_roles" {
  type    = set(string)
  default = [
    "roles/pubsub.publisher", "roles/pubsub.subscriber", "roles/pubsub.viewer", "roles/pubsub.editor",
    "roles/monitoring.admin", "roles/cloudtrace.admin", "roles/monitoring.viewer"
  ]
}

// metadata manager
variable "mde_metadata_manager_sa_id" {
  type    = string
  default = "metadata-manager"
}
variable "mde_metadata_manager_sa_roles" {
  type    = set(string)
  default = [
    "roles/monitoring.admin", "roles/bigquery.admin", "roles/cloudsql.client",
    "roles/storage.objectAdmin", "roles/redis.admin", "roles/pubsub.admin", "roles/pubsub.subscriber",
    "roles/pubsub.viewer", "roles/monitoring.viewer",
    "roles/cloudtrace.admin"
  ]
}

// metadata manager
variable "mde_ui_sa_id" {
  type    = string
  default = "mde-ui"
}
variable "mde_ui_sa_roles" {
  type    = set(string)
  default = [
    "roles/monitoring.admin"
  ]
}
// bq sink
variable "mde_bigquery_sink_sa_id" {
  type    = string
  default = "bigquery-sink"
}
variable "mde_bigquery_sink_sa_roles" {
  type    = set(string)
  default = [
    "roles/monitoring.admin", "roles/bigquery.admin", "roles/pubsub.admin", "roles/pubsub.editor",
    "roles/cloudtrace.admin", "roles/pubsub.subscriber", "roles/pubsub.viewer", "roles/monitoring.viewer",
  ]
}

// pubsub_sink sink
variable "mde_pubsub_sink_sa_id" {
  type    = string
  default = "pubsub-sink"
}
variable "mde_pubsub_sink_sa_roles" {
  type    = set(string)
  default = [
    "roles/monitoring.admin", "roles/cloudtrace.admin", "roles/bigtable.admin", "roles/bigquery.admin",
    "roles/pubsub.publisher", "roles/pubsub.subscriber", "roles/pubsub.viewer", "roles/pubsub.editor"
  ]
}
// mde gateway
variable "mde_gateway_sa_id" {
  type    = string
  default = "mde-gateway"
}
variable "mde_gateway_sa_roles" {
  type    = set(string)
  default = [
    "roles/monitoring.admin"
  ]
}


variable "mde_config_manager_sa_id" {
  type    = string
  default = "config-manager"
}
variable "mde_config_manager_sa_roles" {
  type    = set(string)
  default = [
    "roles/bigtable.admin", "roles/monitoring.admin", "roles/bigquery.admin",
    "roles/cloudsql.client", "roles/storage.objectAdmin"
  ]
}


variable "mde_federation_api_sa_id" {
  type    = string
  default = "fed-api"
}
variable "mde_federation_api_sa_roles" {
  type    = set(string)
  default = [
    "roles/bigquery.jobUser", "roles/bigtable.admin", "roles/monitoring.admin",
    "roles/bigquery.dataViewer", "roles/pubsub.admin"
  ]
}

variable "mde_gke_custom_metrics_sa_id" {
  type    = string
  default = "custom-metrics"
}
variable "mde_gke_custom_metrics_sa_roles" {
  type    = set(string)
  default = [
    "roles/monitoring.viewer",
    "roles/pubsub.editor", "roles/monitoring.admin", "roles/editor"
  ]
}


// Artifact Registry
variable "mde_artifact_registry_sa_path" {
  description = "Full path for the service account with permissions on the Artifact Registry."
}
variable "mde_artifact_registry_url" {
  description = "Artifact Registry that holds the container images."
  default     = "europe-docker.pkg.dev"
}
variable "mde_container_registry_subpath" {
  description = "Sub path for the images within Artifact Registry."
  default     = "imgs"
}


//K8s Namespace names and Secret
variable "mde_k8s_pull_secret" {
  type    = string
  default = "images-pull-secret"
}
#variable "mde_config_manager_secret" {
#  type    = string
#  default = "config-manager"
#}

variable "mde_configuration_manager_secret" {
  type    = string
  default = "configuration-manager"
}
variable "mde_metadata_manager_secret" {
  type    = string
  default = "metadata-manager"
}

variable "mde_deployment_namespace" {
  type    = string
  default = ""
}
variable "mde_cache_host" {
  type = string
}
variable "mde_cache_readendpoint_ip" {
  type = string
}
variable "mde_cache_port" {
  type    = number
  default = 6378
}
variable "mde_cache_authString" {
  type = string
}
variable "mde_deployment_gateway_externalIPName" {
  type    = string
  default = "mde-external"
}
variable "mde_deployment_gateway_externalDevelopmentIPName" {
  type    = string
  default = "mde-development-external"
}
variable "mde_deployment_gateway_domainName" {
  type = string
}

variable "mde_container_namespace_names" {
  type    = set(string)
  default = [
    #"config-manager", "timeseries", "config-viewer", "workflows-deployer",
    #"federation-api",
    "mde"
  ]
}

variable "mde_ui_enabled" {
  type    = bool
  default = false
}

variable "mde_ui_ext_http_lb_static_ip" {
  type        = string
  description = "Static IP of the external HTTP Load Balancer"
  default     = ""
}

variable "mde_ui_ext_http_lb" {
  type = object({
    enabled = bool
    domain  = string

  })
  default = {
    enabled = false
    domain  = ""
  }
  validation {
    #condition     = var.mde_ui_ext_http_lb.enabled && var.mde_ui_ext_http_lb.domain != ""
    condition     = !var.mde_ui_ext_http_lb.enabled || (var.mde_ui_ext_http_lb.enabled && var.mde_ui_ext_http_lb.domain != "")
    error_message = "If the External HTTP Load Balancer is enabled, you must provide a value for the domain name (mde_ui_ext_http_lb.domain)"
  }
}

variable "mde_ui_int_http_lb_static_ip" {
  type        = string
  description = "Static IP of the internal HTTP Load Balancer"
  default     = ""
}

variable "mde_ui_int_http_lb" {
  type = object({
    enabled   = bool
    cert_name = string
  })
  default = {
    enabled   = true
    cert_name = ""
  }
  description = <<EOT
      {
        "enabled":"To determine if an internal HTTP Load Balancer should be deployed with MDE UI",
        "cert_name":"The self-managed SSL certificate name associated with the internal HTTP Load Balancer",
      }
  EOT
}

variable "mde_deployment_mdeui_config_server_host" {
  type    = string
  default = null
}

variable "mde_deployment_mdeui_config_server_port" {
  type    = string
  default = "80"
}

variable "mde_container_namespace" {
  type    = string
  default = "mde"
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
variable "mde_helm_mdeui_chart_path" {
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
variable "mde_helm_custom_metrics_chart_path" {
  type    = string
  default = "../charts"
}

variable "mde_deployment_mdeui_container_tag" {
  type    = string
  default = "2.15.0.0.109.2"
}

variable "mde_deployment_gkename" {
  description = "Dependency-variable"
  type        = string
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


variable "mde_size_details" {
  type = map(object({
    max_connections                 = number
    dataflow_gcswriter_machine      = string
    dataflow_gcswriter_maxworkers   = number
    dataflow_gcswriter_enabled      = bool
    dataflow_gcsreader_machine      = string
    dataflow_gcsreader_maxworkers   = number
    dataflow_gcsreader_enabled      = bool
    dataflow_btwriter_machine       = string
    dataflow_btwriter_maxworkers    = number
    dataflow_btwriter_enabled       = bool
    dataflow_eventchange_machine    = string
    dataflow_eventchange_maxworkers = number
    dataflow_eventchange_enabled    = bool
    dataflow_window_machine         = string
    dataflow_window_maxworkers      = number
    dataflow_window_enabled         = bool
    config_manager_replicas         = number
    configurationmanager_replicas   = number
    bigquery_sink_replicas          = number
    message_mapper_replicas         = number
    metadata_manager_replicas       = number
    mde_gateway_replicas            = number
    federation_api_replicas         = number
    mdegateway_replicas             = number
    mdeui_replicas                  = number
    pubsub_sink_replicas            = number
    time_series_replicas            = number
    bigtable_writer_replicas        = number
    auto_sharding                   = bool
    mde_deployment_node_selector    = string
  }))


  default = {
    Pilot = {
      dataflow_gcswriter_machine      = "n1-standard-1"
      dataflow_gcswriter_maxworkers   = 1
      dataflow_gcswriter_enabled      = true
      dataflow_gcsreader_machine      = "n1-standard-1"
      dataflow_gcsreader_maxworkers   = 1
      dataflow_gcsreader_enabled      = false
      dataflow_btwriter_machine       = "n1-standard-1"
      dataflow_btwriter_maxworkers    = 1
      dataflow_btwriter_enabled       = false
      dataflow_eventchange_machine    = "n1-standard-1"
      dataflow_eventchange_maxworkers = 1
      dataflow_eventchange_enabled    = false
      dataflow_window_machine         = "n1-standard-1"
      dataflow_window_maxworkers      = 1
      dataflow_window_enabled         = false
      max_connections                 = 500
      config_manager_replicas         = 2
      configurationmanager_replicas   = 2
      bigquery_sink_replicas          = 2
      message_mapper_replicas         = 4
      metadata_manager_replicas       = 2
      mde_gateway_replicas            = 2
      federation_api_replicas         = 1
      mdegateway_replicas             = 1
      mdeui_replicas                  = 1
      pubsub_sink_replicas            = 1
      time_series_replicas            = 1
      bigtable_writer_replicas        = 2
      auto_sharding                   = false
      mde_deployment_node_selector    = ""
    }
    Small = {
      max_connections                 = 500
      dataflow_gcswriter_machine      = "n1-standard-2"
      dataflow_gcswriter_maxworkers   = 1
      dataflow_gcswriter_enabled      = true
      dataflow_gcsreader_machine      = "n1-standard-2"
      dataflow_gcsreader_maxworkers   = 1
      dataflow_gcsreader_enabled      = true
      dataflow_btwriter_machine       = "n1-standard-2"
      dataflow_btwriter_maxworkers    = 1
      dataflow_btwriter_enabled       = true
      dataflow_eventchange_machine    = "n1-standard-2"
      dataflow_eventchange_maxworkers = 1
      dataflow_eventchange_enabled    = true
      dataflow_window_machine         = "n1-standard-2"
      dataflow_window_maxworkers      = 1
      dataflow_window_enabled         = true
      config_manager_replicas         = 2
      configurationmanager_replicas   = 2
      bigquery_sink_replicas          = 2
      message_mapper_replicas         = 4
      metadata_manager_replicas       = 2
      mde_gateway_replicas            = 2
      federation_api_replicas         = 1
      mdegateway_replicas             = 1
      mdeui_replicas                  = 1
      pubsub_sink_replicas            = 1
      time_series_replicas            = 1
      bigtable_writer_replicas        = 2
      auto_sharding                   = false
      mde_deployment_node_selector    = ""
    }
    Medium = {
      max_connections                 = 1000
      dataflow_gcswriter_machine      = "n1-standard-4"
      dataflow_gcswriter_maxworkers   = 5
      dataflow_gcswriter_enabled      = true
      dataflow_gcsreader_machine      = "n1-standard-4"
      dataflow_gcsreader_maxworkers   = 2
      dataflow_gcsreader_enabled      = true
      dataflow_btwriter_machine       = "n1-standard-4"
      dataflow_btwriter_maxworkers    = 3
      dataflow_btwriter_enabled       = true
      dataflow_eventchange_machine    = "n1-standard-4"
      dataflow_eventchange_maxworkers = 3
      dataflow_eventchange_enabled    = true
      dataflow_window_machine         = "n1-standard-4"
      dataflow_window_maxworkers      = 3
      dataflow_window_enabled         = true
      config_manager_replicas         = 20
      configurationmanager_replicas   = 20
      bigquery_sink_replicas          = 20
      message_mapper_replicas         = 40
      metadata_manager_replicas       = 22
      mde_gateway_replicas            = 2
      federation_api_replicas         = 4
      mdegateway_replicas             = 4
      mdeui_replicas                  = 2
      pubsub_sink_replicas            = 4
      time_series_replicas            = 4
      bigtable_writer_replicas        = 4
      auto_sharding                   = true
      mde_deployment_node_selector    = "cloud.google.com/compute-class: Scale-Out"
    }
    Large = {
      max_connections                 = 4000
      dataflow_gcswriter_machine      = "n1-highmem-4"
      dataflow_gcswriter_maxworkers   = 10
      dataflow_gcswriter_enabled      = true
      dataflow_gcsreader_machine      = "n1-highmem-4"
      dataflow_gcsreader_maxworkers   = 2
      dataflow_gcsreader_enabled      = true
      dataflow_btwriter_machine       = "n1-highmem-4"
      dataflow_btwriter_maxworkers    = 5
      dataflow_btwriter_enabled       = true
      dataflow_eventchange_machine    = "n1-highmem-4"
      dataflow_eventchange_maxworkers = 5
      dataflow_eventchange_enabled    = true
      dataflow_window_machine         = "n1-highmem-4"
      dataflow_window_maxworkers      = 5
      dataflow_window_enabled         = true
      config_manager_replicas         = 50
      configurationmanager_replicas   = 50
      bigquery_sink_replicas          = 50
      message_mapper_replicas         = 50
      metadata_manager_replicas       = 50
      mde_gateway_replicas            = 5
      federation_api_replicas         = 10
      mdegateway_replicas             = 5
      mdeui_replicas                  = 5
      pubsub_sink_replicas            = 5
      time_series_replicas            = 5
      bigtable_writer_replicas        = 20
      auto_sharding                   = true
      mde_deployment_node_selector    = "cloud.google.com/compute-class: Scale-Out"
    }
  }
}

variable "mde_version" {
  type    = string
  default = "1.3.5"
}

variable "mde_artifacts_release_tag" {
  type    = string
  default = "latest"
}


variable "mde_deployment_config_manager_container_image_tag" {
  type    = string
  default = "latest"
}

variable "mde_deployment_fedapi_container_image_tag" {
  type    = string
  default = "latest"
}
variable "mde_deployment_messagemapper_container_image_tag" {
  type    = string
  default = "latest"
}
variable "mde_deployment_metadatamanager_container_image_tag" {
  type    = string
  default = "latest"
}
variable "mde_deployment_pubsub_sink_container_image_tag" {
  type    = string
  default = "latest"
}
variable "mde_deployment_bigquerysink_container_image_tag" {
  type    = string
  default = "latest"
}
variable "mde_deployment_mdesimulator_container_image_tag" {
  type    = string
  default = "latest"
}
variable "mde_deployment_mdeui_container_image_tag" {
  type    = string
  default = "latest"
}

variable "mde_deployment_custom_metricsr_image_tag" {
  type    = string
  default = "v0.13.1-gke.0"
}