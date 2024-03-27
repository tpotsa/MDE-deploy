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
  cloudsql_instance_name                   = var.mde_dev_mode ? format("%s-%s", var.mde_cloudsql_name_config_manager, random_integer.random_db_id.result) : var.mde_cloudsql_name_config_manager
  config_manager_cloudsql_default_password = var.mde_secret_cloudsql_config_manager-root-password == "" ? random_password.config_manager_cloudsql_password.result : var.mde_secret_cloudsql_config_manager-root-password
}

resource "random_integer" "random_db_id" {
  min = 1
  max = 50000
}
resource "random_password" "config_manager_cloudsql_password" {
  length  = 8
  lower   = true
  upper   = true
  numeric  = true
  special = true
}

data "google_compute_network" "mde_custom_network" {
  count = var.mde_data_store == "sql" ? 1 : 0
  name  = var.mde_network
}

resource "google_sql_database_instance" "mde_cloudsql" {
  count               = var.mde_data_store == "sql" ? 1 : 0
  name                = local.cloudsql_instance_name
  database_version    = var.mde_cloudsql_version_config_manager
  region              = var.mde_region
  deletion_protection = false

  settings {
    tier              = var.mde_size_details[var.mde_size].mde_cloudsql_tier_config_manager
    disk_size         = var.mde_cloudsql_disk_size_config_manager
    disk_type         = "PD_SSD"
    availability_type = "REGIONAL"
    user_labels       = var.mde_deployment_labels
    database_flags {
      name  = "max_connections"
      value =  var.mde_size_details[var.mde_size].max_connections
    }
    backup_configuration {
      enabled                        = true
      binary_log_enabled             = false
      transaction_log_retention_days = 7
      point_in_time_recovery_enabled = false
      start_time                     = "04:00"
      location                       = "US"
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
    ip_configuration {
      ipv4_enabled    = false
      require_ssl     = false
      private_network = "projects/${var.mde_project_id}/global/networks/${var.mde_network}"
    }
    database_flags {
      name  = "lock_timeout"
      value = "3000"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_sql_user" "root_user" {
  count           = var.mde_data_store == "sql" ? 1 : 0
  name            = "root"
  deletion_policy = "ABANDON"
  instance        = google_sql_database_instance.mde_cloudsql[0].name
  password        = local.config_manager_cloudsql_default_password

  lifecycle {
    prevent_destroy = true
  }
}

#resource "google_sql_database" "mde_cloudsql_config_manager_database" {
#  count     = var.mde_data_store == "sql" ? 1 : 0
#  instance  = google_sql_database_instance.mde_cloudsql[0].name
#  name      = var.mde_cloudsql_database_config_manager
#  charset   = "utf8"

#  lifecycle {
#    prevent_destroy = true
#  }
#}

resource "google_sql_database" "mde_cloudsql_configuration_manager_database" {
  count     = var.mde_data_store == "sql" ? 1 : 0
  instance  = google_sql_database_instance.mde_cloudsql[0].name
  name      = var.mde_cloudsql_database_configuration_manager
  charset   = "utf8"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_sql_database" "mde_cloudsql_metadata_manager_database" {
  count     = var.mde_data_store == "sql" ? 1 : 0
  instance  = google_sql_database_instance.mde_cloudsql[0].name
  name      = var.mde_cloudsql_database_metadata_manager
  charset   = "utf8"

  lifecycle {
    prevent_destroy = true
  }
}
