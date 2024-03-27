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

terraform {
  required_version = ">= 1.5.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.71.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.71.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
  backend "gcs" {
  }
}
provider "google" {
  alias = "impersonate"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = var.mde_tf_sa
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "3600s"
}

provider "google" {
  project = var.mde_project_id
  region  = var.mde_region


  access_token    = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}

provider "google-beta" {
  project = var.mde_project_id
  region  = var.mde_region

  access_token    = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}

provider "kubernetes" {
  # config_path            = "~/.kube/config"
  host                   = "https://${data.google_container_cluster.mde_gke_cluster.endpoint}"
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.mde_gke_cluster.master_auth[0].cluster_ca_certificate)

}

provider "helm" {
  kubernetes {
    # config_path            = "~/.kube/config"
    host                   = "https://${data.google_container_cluster.mde_gke_cluster.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.mde_gke_cluster.master_auth[0].cluster_ca_certificate)
  }
  debug = true
}
