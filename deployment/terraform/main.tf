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

module "mde_api_services_enabled" {
  count  = var.mde_network_enabled && var.mde_infrastructure_enabled ? 1 : 0
  source = "./modules/api-services"

  mde_disable_api_on_destroy = var.mde_disable_api_on_destroy
}
module "mde_network" {
  count = var.mde_network_enabled ? 1 : 0

  source                 = "./modules/network"
  mde_deployment_labels  = var.mde_deployment_labels
  mde_network_project_id = var.mde_network_project_id != "" ? var.mde_network_project_id : var.mde_project_id
  depends_on             = [module.mde_api_services_enabled]
  mde_region             = var.mde_region
}

/*
//Use this mde_network module in cases where you have already deployed MC
//following the deployment guide on Marketplace/github in the GCP project
module "mde_network" {
  count = var.mde_network_enabled ? 1 : 0

  source                = "./modules/network-external"
  mde_deployment_labels = var.mde_deployment_labels
  mde_project_id      = var.mde_project_id

  depends_on = [module.mde_api_services_enabled]
}
*/

module "mde_private_service_access" {
  source = "./modules/private-service-access"

  mde_network_name = var.mde_network_enabled ? module.mde_network[0].mde_network_name : var.mde_network_name
  mde_project_id   = var.mde_project_id
  mde_data_store   = var.mde_data_store

  depends_on = [module.mde_network]
}

module "mde_infrastructure" {
  count                   = var.mde_infrastructure_enabled ? 1 : 0
  source                  = "./modules/infrastructure"
  mde_version             = var.mde_version
  mde_project_id          = var.mde_project_id
  mde_bigquery_project_id = var.mde_bigquery_project_id
  mde_region              = var.mde_region
  mde_zone                = var.mde_zone
  mde_dev_mode            = var.mde_dev_mode
  mde_size                = var.mde_size

  mde_network          = var.mde_network_enabled ? module.mde_network[0].mde_network_name : var.mde_network_name
  mde_subnet_name      = var.mde_network_enabled ? module.mde_network[0].mde_deployment_subnetwork_name : var.mde_deployment_subnet_name
  mde_subnet_self_link = module.mde_network[0].mde_deployment_subnetwork_self_link

  mde_bigquery_location            = var.mde_bigquery_location
  mde_storage_config_multi-cluster = var.mde_storage_config_multi-cluster
  mde_bt_enabled                   = var.mde_bt_enabled
  mde_deployment_labels            = var.mde_deployment_labels
  mde_gke_labels                   = var.mde_gke_labels

  mde_data_store                                   = var.mde_data_store
  mde_secret_cloudsql-root-password                = var.mde_secret_cloudsql-root-password
  mde_secret_oauth_client_id                       = var.mde_secret_oauth_client_id
  mde_secret_oauth_client_secret                   = var.mde_secret_oauth_client_secret
  mde_secret_cloudsql_config_manager-root-password = var.mde_secret_cloudsql_config_manager-root-password

  depends_on = [
    module.mde_api_services_enabled, module.mde_private_service_access,
    module.mde_network
  ]
}

data "google_client_config" "provider" {}
data "google_container_cluster" "mde_gke_cluster" {
  name       = var.mde_infrastructure_enabled ? module.mde_infrastructure[0].mde_gke_name : var.mde_gke_name
  location   = var.mde_infrastructure_enabled ? module.mde_infrastructure[0].mde_gke_location : var.mde_gke_location
  depends_on = [module.mde_infrastructure]
}
module "mde_deployments" {
  source                            = "./modules/deployment"
  mde_version                       = var.mde_version
  mde_artifacts_release_tag         = var.mde_artifacts_release_tag
  mde_project_id                    = var.mde_project_id
  mde_bigquery_project_id           = var.mde_bigquery_project_id
  mde_region                        = var.mde_region
  mde_artifact_registry_sa_path     = var.mde_artifact_registry_sa_path
  mde_container_registry_project_id = var.mde_container_registry_project_id
  mde_container_registry_subpath    = var.mde_container_registry_subpath
  mde_artifact_registry_url         = var.mde_artifact_registry_url
  mde_grafana_enabled               = var.mde_grafana_enabled
  mde_data_store                    = var.mde_data_store
  mde_size                          = var.mde_size
  mde_tf_sa                         = var.mde_tf_sa
  mde_dataflow_sa                   = var.mde_dataflow_sa
  mde_dev_mode                      = var.mde_dev_mode
  mde_subnet_self_link              = module.mde_network[0].mde_deployment_subnetwork_self_link
  mde_deployment_gkename            = module.mde_infrastructure[0].mde_gke_name
  mde_ui_enabled                    = var.mde_ui_enabled
  mde_ui_ext_http_lb                = {
    enabled = var.mde_ui_ext_http_lb.enabled
    domain  = var.mde_ui_ext_http_lb.domain
  }
  mde_helm_federation_api_chart_path            = var.mde_helm_federation_api_chart_path
  mde_helm_configurationmanager_chart_path      = var.mde_helm_configurationmanager_chart_path
  mde_helm_messagemapper_chart_path             = var.mde_helm_messagemapper_chart_path
  mde_helm_metadatamanager_chart_path           = var.mde_helm_metadatamanager_chart_path
  mde_helm_pubsub_sink_chart_path               = var.mde_helm_pubsub_sink_chart_path
  mde_helm_bigquerysink_chart_path              = var.mde_helm_bigquerysink_chart_path
  mde_helm_mdesimulator_chart_path              = var.mde_helm_mdesimulator_chart_path
  mde_helm_mdeui_chart_path                     = var.mde_helm_mdeui_chart_path
  mde_deployment_gateway_domainName             = var.mde_deployment_gateway_domainName
  mde_dataflow_flex_template_bucket             = var.mde_dataflow_flex_template_bucket
  mde_bigtable_name                             = var.mde_infrastructure_enabled ? module.mde_infrastructure[0].mde_bigtable_instance_name : var.mde_bigtable_name
  mde_bigquery_name                             = var.mde_infrastructure_enabled ? module.mde_infrastructure[0].mde_bigquery_instance_name : var.mde_bigquery_name
  mde_cloudsql_name                             = var.mde_infrastructure_enabled ? module.mde_infrastructure[0].mde_cloudsql_instance_name : var.mde_cloudsql_name
  mde_cloudsql_username                         = var.mde_infrastructure_enabled ? module.mde_infrastructure[0].mde_cloudsql_instance_username : var.mde_cloudsql_username
  mde_cloudsql_password                         = var.mde_infrastructure_enabled ? module.mde_infrastructure[0].mde_cloudsql_instance_password : var.mde_secret_cloudsql_config_manager-root-password
  mde_deployment_subnet_name                    = var.mde_network_enabled ? module.mde_network[0].mde_deployment_subnetwork_name : var.mde_deployment_subnet_name
  mde_dns_zone_name                             = var.mde_network_enabled ? module.mde_network[0].mde_dns_zone_name : var.mde_dns_zone_name
  mde_helm_workflows_deployer_subnet_project_id = var.mde_network_enabled ? module.mde_network[0].mde_deployment_subnetwork_project_id : var.mde_network_project_id
  mde_cache_host                                = module.mde_infrastructure[0].mde_cache_host
  mde_cache_port                                = module.mde_infrastructure[0].mde_cache_port
  mde_cache_readendpoint_ip                     = module.mde_infrastructure[0].mde_cache_readendpoint_ip
  mde_cache_authString                          = module.mde_infrastructure[0].mde_cache_authString


  mde_helm_custom_metrics_chart_path = var.mde_helm_custom_metrics_chart_path

  depends_on = [
    module.mde_api_services_enabled, module.mde_network,
    module.mde_infrastructure
  ]
}
module "mde_monitoring" {
  source     = "./modules/monitoring"
  depends_on = [
    module.mde_api_services_enabled, module.mde_infrastructure
  ]
}
