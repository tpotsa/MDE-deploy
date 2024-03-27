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

// Config Manager SA
resource "google_service_account" "mde_configuration_manager_sa" {
  project = var.mde_project_id
  account_id   = var.mde_configuration_manager_sa_id
  display_name = var.mde_configuration_manager_sa_id
  description  = "SA for the configuration manager deployment on GKE"
}
resource "google_project_iam_member" "mde_configuration_manager_sa_binding" {
  for_each = var.mde_configuration_manager_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_configuration_manager_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_configuration_manager_workload_identity_binding" {
  service_account_id = google_service_account.mde_configuration_manager_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/configuration-manager]"]
}

// Message-Mapper SA
resource "google_service_account" "mde_message_mapper_sa" {
  project = var.mde_project_id
  account_id   = var.mde_message_mapper_sa_id
  display_name = var.mde_message_mapper_sa_id
  description  = "SA for the Message Mapper deployment on GKE"
}
resource "google_project_iam_member" "mde_message_mapper_sa_binding" {
  for_each = var.mde_message_mapper_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_message_mapper_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_message_mapper_workload_identity_binding" {
  service_account_id = google_service_account.mde_message_mapper_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/message-mapper]"]
}


// Metadata Manager SA
resource "google_service_account" "mde_metadata_manager_sa" {
  project = var.mde_project_id
  account_id   = var.mde_metadata_manager_sa_id
  display_name = var.mde_metadata_manager_sa_id
  description  = "SA for the Metadata Manager deployment on GKE"
}
resource "google_project_iam_member" "mde_metadata_manager_sa_binding" {
  for_each = var.mde_metadata_manager_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_metadata_manager_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_metadata_manager_workload_identity_binding" {
  service_account_id = google_service_account.mde_metadata_manager_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/metadata-manager]"]
}

//BQ Sink SA
resource "google_service_account" "mde_bigquery_sink_sa" {
  project = var.mde_project_id
  account_id   = var.mde_bigquery_sink_sa_id
  display_name = var.mde_bigquery_sink_sa_id
  description  = "SA for the BQ Sink deployment on GKE"
}
resource "google_project_iam_member" "mde_bigquery_sink_sa_binding" {
  for_each = var.mde_bigquery_sink_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_bigquery_sink_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_bigquery_sink_workload_identity_binding" {
  service_account_id = google_service_account.mde_bigquery_sink_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/bigquery-sink]"]
}


#
// Config Manager SA
resource "google_service_account" "mde_config_manager_sa" {
  project = var.mde_project_id
  account_id   = var.mde_config_manager_sa_id
  display_name = var.mde_config_manager_sa_id
  description  = "SA for the configuration manager deployment on GKE"
}
resource "google_project_iam_member" "mde_config_manager_sa_binding" {
  for_each = var.mde_config_manager_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_config_manager_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_config_manager_workload_identity_binding" {
  service_account_id = google_service_account.mde_config_manager_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/config-manager]"]
}

//Dataflow account
/*resource "google_service_account" "mde_dataflow_sa" {
  project = var.mde_project_id
  account_id   = var.mde_dataflow_sa
  display_name = var.mde_dataflow_sa
  description  = "SA for the BT Sink deployment on DataflowFlex"
}*/


resource "google_project_iam_member" "mde_dataflow_sa_binding" {
  for_each = var.mde_dataflow_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${var.mde_dataflow_sa}"
  role     = each.value
}

// Grant TF-SA the usage of DF-SA
data "google_iam_policy" "mde_serviceaccount_policy_accountuser_df_to_tf" {
  binding {
    role = "roles/iam.serviceAccountUser"
    members = [
      "serviceAccount:${var.mde_tf_sa}",
    ]
  }
}
resource "google_service_account_iam_policy" "mde_bigtable_dfsink_sa_WorkloadIdentityAUPolicy" {
  policy_data        = data.google_iam_policy.mde_serviceaccount_policy_accountuser_df_to_tf.policy_data
  service_account_id = "projects/${var.mde_project_id}/serviceAccounts/${var.mde_dataflow_sa}"
}


locals {
  sa_artifact_registry_sa_key   = file(var.mde_artifact_registry_sa_path)
  sa_artifact_registry_sa_email = regex("(?P<client>\"client_email\":\\s\")(?P<sa_email>.+)\",", local.artifact_registry_sa_key)

}

// Federation API SA
resource "google_service_account" "mde_federation_api_sa" {
  project = var.mde_project_id
  account_id   = var.mde_federation_api_sa_id
  display_name = var.mde_federation_api_sa_id
  description  = "SA for the federation API deployment on GKE"
}
resource "google_project_iam_member" "mde_federation_api_sa_binding" {
  for_each = var.mde_federation_api_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_federation_api_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_federation_api_workload_identity_binding" {
  service_account_id = google_service_account.mde_federation_api_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/fed-api]"]
}

// Federation API SA
resource "google_service_account" "mde_gke_custom_metrics_sa" {
  project = var.mde_project_id
  account_id   = var.mde_gke_custom_metrics_sa_id
  display_name = var.mde_gke_custom_metrics_sa_id
  description  = "SA for the federation API deployment on GKE"
}
resource "google_project_iam_member" "mde_gke_custom_metrics_sa_binding" {
  for_each = var.mde_gke_custom_metrics_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_gke_custom_metrics_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_gke_custom_metrics_workload_identity_binding" {
  service_account_id = google_service_account.mde_gke_custom_metrics_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace_custom_metrics.metadata[0].name}/custom-metrics]"]
}

// Binding for custom metrics
resource "kubernetes_cluster_role_binding_v1" "mde_gke_custom_metrics_sa_binding" {
 metadata {
    name = "cluster-admin-metrics"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "custom-metrics"
    namespace = "custom-metrics"
    api_group = ""
    // api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "metadata-manager"
    namespace = "mde"
    api_group = ""
    // api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "message-mapper"
    namespace = "mde"
    api_group = ""
    // api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "configuration-manager"
    namespace = "mde"
    api_group = ""
    // api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "fed-api"
    namespace = "mde"
    api_group = ""
    // api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "bigquery-sink"
    namespace = "mde"
    api_group = ""
    // api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [
    google_service_account_iam_binding.mde_gke_custom_metrics_workload_identity_binding,
    google_service_account_iam_binding.mde_metadata_manager_workload_identity_binding,
    google_service_account_iam_binding.mde_message_mapper_workload_identity_binding,
    kubernetes_secret.mde_image_pull_secret
  ]
}

// UI SA
resource "google_service_account" "mde_ui_sa" {
  project = var.mde_project_id
  account_id   = var.mde_ui_sa_id
  display_name = var.mde_ui_sa_id
  description  = "SA for the MDE UI deployment on GKE"
}
resource "google_project_iam_member" "mde_ui_sa_binding" {
  for_each = var.mde_ui_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_ui_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_ui_workload_identity_binding" {
  service_account_id = google_service_account.mde_ui_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/mdeui]"]
}

// pubsub_sink SA
resource "google_service_account" "mde_pubsub_sink_sa" {
  project = var.mde_project_id
  account_id   = var.mde_pubsub_sink_sa_id
  display_name = var.mde_pubsub_sink_sa_id
  description  = "SA for the MDE pubsub_sink deployment on GKE"
}
resource "google_project_iam_member" "mde_pubsub_sink_sa_binding" {
  for_each = var.mde_pubsub_sink_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_pubsub_sink_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_pubsub_sink_workload_identity_binding" {
  service_account_id = google_service_account.mde_pubsub_sink_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/pubsub-sink]"]
}

// Gateway SA
resource "google_service_account" "mde_gateway_sa" {
  project = var.mde_project_id
  account_id   = var.mde_gateway_sa_id
  display_name = var.mde_gateway_sa_id
  description  = "SA for the MDE UI deployment on GKE"
}
resource "google_project_iam_member" "mde_gateway_sa_binding" {
  for_each = var.mde_gateway_sa_roles
  project = var.mde_project_id
  member   = "serviceAccount:${google_service_account.mde_gateway_sa.email}"
  role     = each.value
}
resource "google_service_account_iam_binding" "mde_gateway_workload_identity_binding" {
  service_account_id = google_service_account.mde_gateway_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.mde_project_id}.svc.id.goog[${kubernetes_namespace.mde_container_namespace.metadata[0].name}/mdegateway]"]
}
