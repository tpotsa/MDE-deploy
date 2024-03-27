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
variable "mde_zone" {
  description = "Default zone where all services are being provisioned."
}
variable "mde_secret_oauth_client_id" {
  type      = string
  sensitive = true
}
variable "mde_secret_oauth_client_secret" {
  type      = string
  sensitive = true
}
variable "mde_secret_cloudsql-root-password" {
  type      = string
  sensitive = true
}
variable "mde_secret_cloudsql_config_manager-root-password" {
  type      = string
  sensitive = true
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
variable "mde_bt_enabled" {
  type        = bool
  description = "Weather to enable BigTable instances"
  default     = true
}
variable "mde_storage_config_multi-cluster" {
  type        = bool
  description = "To enable multiple cluster deployments for the Bigtable instances."
}
variable "mde_network" {
  type        = string
  description = "Custom Virtual Private Network."
}
variable "mde_subnet_name" {
  type        = string
  description = "Subnet used for all of the data-lake workflows and the GKE cluster."
}
variable "mde_subnet_self_link" {
  type        = string
  description = "Subnet self-link used for all of the data-lake workflows and the GKE cluster."
}

// Variables related to Infrastructure
variable "mde_data_store" {
  type        = string
  default     = "sql"
  description = "Indicates if the solution will deploy a BigTable Instance(bt) or a Postgres CloudSQL instance(sql)"
  validation {
    condition     = contains(["sql", "bt"], var.mde_data_store)
    error_message = "Valid values for data store variable are: sql or bt."
  }
}
variable "mde_dev_mode" {
  type        = bool
  description = "To determine if the cloud solution will run in development mode."
  default     = false
}

// Container
variable "mde_container_name" {
  default = "mde-gke"
}

// Buckets
variable "mde_buckets_name" {
  description = "List of buckets name"
  type        = set(string)
  default     = [
    "staging", "temp", "raw", "batch-ingestion", "config-manager-jobs"
  ]
}

// PubSub
variable "mde_pubsub_topic_names" {
  type    = set(string)
  default = [
    "input-messages",
    "bq-streaming-dead-letter", "configuration-processed",
    "mde-control-events", "mde-processing-dead-letter",
    "mde-system-tables", "message-mapping-processed", "metadata-processed",
    "ingestion-operations",
    "default-clustered-continuous-records-materialization",
    "mde-tag-stream-proto", "mde-tag-stream-json", "gcs-reader"
  ]
}
variable "mde_pubsub_subscriptions_optional" {
  type = set(object({
    topic_name = string
    subs_name  = string
    filter     = string
    #dead_letter= string
  }))
  default = [
    {
      subs_name  = "bq-streaming-dead-letter-sub"
      topic_name = "bq-streaming-dead-letter"
      filter     = ""
    }
  ]
}


variable "mde_pubsub_subscriptions" {
  type = set(object({
    topic_name = string
    subs_name  = string
    filter     = string
  }))
  default = [
    {
      subs_name  = "bq-streaming-dead-letter-sub"
      topic_name = "bq-streaming-dead-letter"
      filter     = ""
    },
    {
      subs_name  = "df-gcs-raw-ingester"
      topic_name = "input-messages"
      filter     = ""
    },
    {
      subs_name  = "gcs-reader-subscription"
      topic_name = "gcs-reader"
      filter     = ""
    },
    {
      subs_name  = "mde-processing-dead-letter-subscription"
      topic_name = "mde-processing-dead-letter"
      filter     = ""
    },
    {
      subs_name  = "event-change-transformation-subscription"
      topic_name = "metadata-processed"
      filter     = "attributes.\"mde.event_change\"=\"true\""
    },
    {
      subs_name  = "window-transformation-subscription"
      topic_name = "metadata-processed"
      filter     = "attributes.\"mde.window\"=\"true\""
    },
    {
      subs_name  = "bigtable-writer-subscription"
      topic_name = "metadata-processed"
      filter     = "attributes.\"mde.big_table\"=\"true\""

    },
    {
      subs_name  = "gcs-writer-subscription"
      topic_name = "metadata-processed"
      filter     = "attributes.\"mde.gcs\"=\"true\""
    },
    {
      subs_name  = "df-gcs-raw-ingester"
      topic_name = "input-messages"
      filter     = ""
    },
    {
      subs_name  = "mde-tag-stream-proto-sub"
      topic_name = "mde-tag-stream-proto"
      filter     = ""
    },
    {
      subs_name  = "mde-tag-stream-json-sub"
      topic_name = "mde-tag-stream-json"
      filter     = ""
    }
  ]
}

variable "mde_pubsub_subscriptions_dead_letter" {
  type = set(object({
    topic_name       = string
    subs_name        = string
    filter           = string
    dead_letter_name = string
  }))
  default = [
    {
      subs_name        = "message-mapper-events-processing-subscription"
      topic_name       = "mde-control-events"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "message-mapping-subscription"
      topic_name       = "input-messages"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "metadata-processing-subscription"
      topic_name       = "configuration-processed"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "metadata-events-processing-subscription"
      topic_name       = "mde-control-events"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "bigquery-sink-events-processing-subscription"
      topic_name       = "mde-control-events"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "configuration-events-processing-subscription"
      topic_name       = "mde-control-events"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "bigquery-sink-system-tables-subscription"
      topic_name       = "mde-system-tables"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "configuration-processing-subscription"
      topic_name       = "message-mapping-processed"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "bigquery-sink-subscription"
      topic_name       = "metadata-processed"
      filter           = "attributes.\"mde.big_query\"=\"true\""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "pubsub-sink-subscription"
      topic_name       = "metadata-processed"
      filter           = "attributes.\"mde.pubsub_proto\"=\"true\" OR attributes.\"mde.pubsub_json\"=\"true\""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "pubsub-sink-events-processing-subscription"
      topic_name       = "mde-control-events"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    },
    {
      subs_name        = "federation-events-processing-subscription"
      topic_name       = "mde-control-events"
      filter           = ""
      dead_letter_name = "mde-processing-dead-letter"
    }
  ]
}


// Storage - BigTable
variable "mde_bigtable_name" {
  type    = string
  default = "mde-timeseries-data"
}
variable "mde_bigtable_cluster_id_name" {
  type    = string
  default = "mde-timeseries-data-c1"
}
variable "mde_bigtable_ap_name" {
  type    = string
  default = "fed-api"
}
variable "mde_bigtable_ap_description" {
  type    = string
  default = "A fast profile for the timeseries ingestion application"
}

variable "mde_bigtable_systemtable_config_name" {
  type    = string
  default = "mde-internal-config"
}

variable "mde_bigtable_systemtable_default_archetypes_name" {
  type    = string
  default = "default-archetypes"
}

variable "mde_bigtable_systemtable_clustered_archetypes_name" {
  type    = string
  default = "clustered-archetypes"
}

// Storage - BigQuery
variable "mde_bigquery_dataset_mde_data_id_name" {
  type    = string
  default = "mde_data"
}
variable "mde_bigquery_dataset_mde_system_id_name" {
  type    = string
  default = "mde_system"
}
variable "mde_bigquery_dataset_mde_dimension_id_name" {
  type    = string
  default = "mde_dimension"
}

variable "mde_bigquery_location" {
  type    = string
  default = "EU"
}


// Storage - CloudSQL - Postgres
variable "mde_cloudsql_database_configuration_manager" {
  type    = string
  default = "mde-configurations"
}
variable "mde_cloudsql_database_metadata_manager" {
  type    = string
  default = "metadata-manager"
}

variable "mde_cloudsql_name_config_manager" {
  type    = string
  default = "mde-sql"
}
variable "mde_cloudsql_version_config_manager" {
  default = "POSTGRES_13"
}
variable "mde_cloudsql_disk_size_config_manager" {
  default = 10
}

// Storage - Redis
variable "mde_cache_instance_name" {
  type    = string
  default = "mde-cache"
}

//// IAM - Service Accounts
variable "mde_container_sa" {
  type    = string
  default = "mde-gke"
}
variable "mde_container_sa_roles" {
  type    = set(string)
  default = [
    "roles/monitoring.viewer", "roles/monitoring.admin",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter", "roles/stackdriver.resourceMetadata.writer"
  ]
}
variable "mde_cloud_build_sa_roles" {
  type    = set(string)
  default = ["roles/cloudfunctions.developer", "roles/iam.serviceAccountUser"]
}
variable "mde_pubsub_sa_roles" {
  type    = set(string)
  default = [
    "roles/pubsub.publisher", "roles/pubsub.subscriber",
    "roles/bigquery.dataEditor"
  ]
}

// Secret Manager
variable "mde_secrets" {
  type    = set(string)
  default = [
    "oauth-client-id", "oauth-client-secret", "cloudsql-root-password",
    "cloudsql-config-manager-root-password"
  ]
}

// Router - NAT
variable "mde_router" {
  type    = string
  default = "mde-nat-router"
}
variable "mde_nat" {
  type    = string
  default = "mde-nat-config"
}
variable "mde_size" {
  type        = string
  default     = "Small"
  description = "Sizing for MDE, should be: Small, Medium, Pilot, Large. Please refer to the documentation for further details."
  validation {
    condition = contains([
      "Small", "Medium", "Pilot", "Large"
    ], var.mde_size)
    error_message = "Valid options for mde_size are: Small, Medium, Pilot, Large."
  }
}


// Proxy
variable "mde_proxy_gce_machine_type" {
  type    = string
  default = "e2-medium"
}
variable "mde_proxy_gce_sa" {
  type    = string
  default = "mde-proxy-gce-sa"
}


variable "mde_size_details" {
  type = map(object({
    mde_cloudsql_tier_config_manager   = string
    max_connections                    = number
    config_manager_replicas            = number
    time_series_replicas               = number
    auto_sharding                      = bool
    mde_proxy_gce_machine_type         = string
    mde_gke_cluster_autoscalingprofile = string
    mde_gke_cluster_cidr_pods          = string
    mde_gke_cluster_cidr_services      = string
    mde_redis_memorysize_gb            = number
    mde_redis_replicacount             = number
    mde_redis_tier                     = string
    mde_bigtable_nodes                 = number
  }))

  default = {
    Pilot = {
      mde_cloudsql_tier_config_manager   = "db-custom-1-3840"
      max_connections                    = 500
      config_manager_replicas            = 4
      time_series_replicas               = 1
      auto_sharding                      = false
      mde_proxy_gce_machine_type         = "e2-micro"
      mde_gke_cluster_autoscalingprofile = "OPTIMIZE_UTILIZATION"
      mde_gke_cluster_cidr_pods          = "/19"
      mde_gke_cluster_cidr_services      = "/22"
      mde_redis_memorysize_gb            = 1
      mde_redis_replicacount             = 0
      mde_redis_tier                     = "BASIC"
      mde_bigtable_nodes                 = 0
    }
    Small = {
      mde_cloudsql_tier_config_manager   = "db-custom-2-7680"
      max_connections                    = 500
      config_manager_replicas            = 5
      time_series_replicas               = 5
      auto_sharding                      = false
      mde_proxy_gce_machine_type         = "e2-micro"
      mde_gke_cluster_autoscalingprofile = "OPTIMIZE_UTILIZATION"
      mde_gke_cluster_cidr_pods          = "/19"
      mde_gke_cluster_cidr_services      = "/22"
      mde_redis_memorysize_gb            = 5
      mde_redis_replicacount             = 2
      mde_redis_tier                     = "STANDARD_HA"
      mde_bigtable_nodes                 = 1
    }
    Medium = {
      mde_cloudsql_tier_config_manager   = "db-custom-16-30720"
      max_connections                    = 1000
      config_manager_replicas            = 50
      time_series_replicas               = 50
      auto_sharding                      = true
      mde_proxy_gce_machine_type         = "e2-medium"
      mde_gke_cluster_autoscalingprofile = "BALANCED"
      mde_gke_cluster_cidr_pods          = "/17"
      mde_gke_cluster_cidr_services      = "/22"
      mde_redis_memorysize_gb            = 20
      mde_redis_replicacount             = 2
      mde_redis_tier                     = "STANDARD_HA"
      mde_bigtable_nodes                 = 3
    }
    Large = {
      mde_cloudsql_tier_config_manager   = "db-custom-32-61440"
      max_connections                    = 4000
      config_manager_replicas            = 200
      time_series_replicas               = 200
      auto_sharding                      = true
      mde_proxy_gce_machine_type         = "e2-medium"
      mde_gke_cluster_autoscalingprofile = "BALANCED"
      mde_gke_cluster_cidr_pods          = "/17"
      mde_gke_cluster_cidr_services      = "/22"
      mde_redis_memorysize_gb            = 40
      mde_redis_replicacount             = 5
      mde_redis_tier                     = "STANDARD_HA"
      mde_bigtable_nodes                 = 5
    }
  }
}

variable "mde_version" {
  type    = string
  default = "1.3.5"
}
