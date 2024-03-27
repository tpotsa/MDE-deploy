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

resource "google_bigtable_instance" "mde_bigtable" {
  count               = var.mde_bt_enabled ? var.mde_size_details[var.mde_size].mde_bigtable_nodes>0 ? 1 :0: 0
  name                = var.mde_bigtable_name
  deletion_protection = false
  cluster {
    cluster_id   = var.mde_bigtable_cluster_id_name
    zone         = var.mde_zone
    num_nodes    = var.mde_size_details[var.mde_size].mde_bigtable_nodes
    storage_type = "SSD"
  }

  labels = var.mde_deployment_labels

  lifecycle {
    prevent_destroy = true
  }
}
resource "google_bigtable_app_profile" "mde_bigtable_ap_multi_cluster" {
  count                         = var.mde_bt_enabled ? var.mde_size_details[var.mde_size].mde_bigtable_nodes>0? var.mde_storage_config_multi-cluster ? 1: 0 : 0 : 0
  instance                      = google_bigtable_instance.mde_bigtable[0].name
  description                   = var.mde_bigtable_ap_description
  app_profile_id                = var.mde_bigtable_ap_name
  multi_cluster_routing_use_any = true
  ignore_warnings               = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_bigtable_app_profile" "mde_bigtable_ap_single_cluster" {
  count          = var.mde_bt_enabled ? var.mde_size_details[var.mde_size].mde_bigtable_nodes>0? var.mde_storage_config_multi-cluster== false ? 1: 0 : 0 : 0
  instance       = google_bigtable_instance.mde_bigtable[0].name
  description    = var.mde_bigtable_ap_description
  app_profile_id = var.mde_bigtable_ap_name
  single_cluster_routing {
    cluster_id                 = var.mde_bigtable_cluster_id_name
    allow_transactional_writes = true
  }
  ignore_warnings = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_bigtable_table" "mde_bigtable_systemtable_config" {
  count               = var.mde_bt_enabled ? var.mde_size_details[var.mde_size].mde_bigtable_nodes>0 ? 1 :0: 0
  instance_name = google_bigtable_instance.mde_bigtable[0].name
  name          = var.mde_bigtable_systemtable_config_name
  column_family {
    family = "compatibility"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_bigtable_table" "mde_bigtable_systemtable_default_archetypes" {
  count               = var.mde_bt_enabled ? var.mde_size_details[var.mde_size].mde_bigtable_nodes>0 ? 1 :0: 0
  instance_name = google_bigtable_instance.mde_bigtable[0].name
  name          = var.mde_bigtable_systemtable_default_archetypes_name
  lifecycle {
    prevent_destroy = true
    ignore_changes = [column_family]
  }
}

resource "google_bigtable_table" "mde_bigtable_systemtable_clustered_archetypes" {
  count               = var.mde_bt_enabled ? var.mde_size_details[var.mde_size].mde_bigtable_nodes>0 ? 1 :0: 0
  instance_name = google_bigtable_instance.mde_bigtable[0].name
  name          = var.mde_bigtable_systemtable_clustered_archetypes_name
  lifecycle {
    prevent_destroy = true
    ignore_changes = [column_family]
  }
}

resource "null_resource" "mde_bigtable_systemtable_config_insertsystemrows" {
  count               = var.mde_bt_enabled ? var.mde_size_details[var.mde_size].mde_bigtable_nodes>0 ? 1 :0: 0
  provisioner "local-exec" {
    command = "../config/bigtable-systemtable-config-insertversionrecords.sh ${var.mde_project_id} ${var.mde_bigtable_name}"
  }
  depends_on = [google_bigtable_table.mde_bigtable_systemtable_config]
}

