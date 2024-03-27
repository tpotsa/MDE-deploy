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


# based on https://raw.githubusercontent.com/GoogleCloudPlatform/k8s-stackdriver/master/custom-metrics-stackdriver-adapter/deploy/production/adapter_new_resource_model.yaml
/*
resource "kubernetes_manifest" "namespace_custom_metrics" {
 # depends_on = [kubernetes_cluster_role_binding_v1.mde_gke_custom_metrics_sa_binding,
    #var.mde_deployment_gkename
#  ]
  #depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "name" = "custom-metrics"
    }
  }
}
resource "kubernetes_manifest" "serviceaccount_custom_metrics_custom_metrics_stackdriver_adapter" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "custom-metrics-stackdriver-adapter"
      "namespace" = "custom-metrics"
    }
  }
}

resource "kubernetes_manifest" "clusterrolebinding_custom_metrics_system_auth_delegator" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "cluster-role-binding-auth.yaml"
    "metadata" = {
      "name" = "custom-metrics:system:auth-delegator"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "system:auth-delegator"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "custom-metrics-stackdriver-adapter"
        "namespace" = "custom-metrics"
      },
    ]
  }
}

resource "kubernetes_manifest" "rolebinding_kube_system_custom_metrics_auth_reader" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "RoleBinding"
    "metadata" = {
      "name" = "custom-metrics-auth-reader"
      "namespace" = "kube-system"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "Role"
      "name" = "extension-apiserver-authentication-reader"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "custom-metrics-stackdriver-adapter"
        "namespace" = "custom-metrics"
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_custom_metrics_custom_metrics_resource_reader" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "custom-metrics-resource-reader"
      "namespace" = "custom-metrics"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "pods",
          "nodes",
          "nodes/stats",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_custom_metrics_resource_reader" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "cluster-role-binding-auth.yaml"
    "metadata" = {
      "name" = "custom-metrics-resource-reader"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "custom-metrics-resource-reader"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "custom-metrics-stackdriver-adapter"
        "namespace" = "custom-metrics"
      },
    ]
  }
}

resource "kubernetes_manifest" "deployment_custom_metrics_custom_metrics_stackdriver_adapter" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "labels" = {
        "k8s-app" = "custom-metrics-stackdriver-adapter"
        "run" = "custom-metrics-stackdriver-adapter"
      }
      "name" = "custom-metrics-stackdriver-adapter"
      "namespace" = "custom-metrics"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "k8s-app" = "custom-metrics-stackdriver-adapter"
          "run" = "custom-metrics-stackdriver-adapter"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "k8s-app" = "custom-metrics-stackdriver-adapter"
            "kubernetes.io/cluster-service" = "true"
            "run" = "custom-metrics-stackdriver-adapter"
          }
        }
        "spec" = {
          "containers" = [
            {
              "command" = [
                "/adapter",
                "--use-new-resource-model=true",
                "--fallback-for-container-metrics=true",
              ]
              "image" = "gcr.io/gke-release/custom-metrics-stackdriver-adapter:v0.13.1-gke.0"
              "imagePullPolicy" = "Always"
              "name" = "pod-custom-metrics-stackdriver-adapter"
              "resources" = {
                "limits" = {
                  "cpu" = "250m"
                  "memory" = "200Mi"
                }
                "requests" = {
                  "cpu" = "250m"
                  "memory" = "200Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "custom-metrics-stackdriver-adapter"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_custom_metrics_custom_metrics_stackdriver_adapter" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "k8s-app" = "custom-metrics-stackdriver-adapter"
        "kubernetes.io/cluster-service" = "true"
        "kubernetes.io/name" = "Adapter"
        "run" = "custom-metrics-stackdriver-adapter"
      }
      "name" = "custom-metrics-stackdriver-adapter"
      "namespace" = "custom-metrics"
    }
    "spec" = {
      "ports" = [
        {
          "port" = 443
          "protocol" = "TCP"
          "targetPort" = 443
        },
      ]
      "selector" = {
        "k8s-app" = "custom-metrics-stackdriver-adapter"
        "run" = "custom-metrics-stackdriver-adapter"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "apiservice_v1beta1_custom_metrics_k8s_io" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "apiregistration.k8s.io/v1"
    "kind" = "APIService"
    "metadata" = {
      "name" = "v1beta1.custom.metrics.k8s.io"
    }
    "spec" = {
      "group" = "custom.metrics.k8s.io"
      "groupPriorityMinimum" = 100
      "insecureSkipTLSVerify" = true
      "service" = {
        "name" = "custom-metrics-stackdriver-adapter"
        "namespace" = "custom-metrics"
      }
      "version" = "v1beta1"
      "versionPriority" = 100
    }
  }
}

resource "kubernetes_manifest" "apiservice_v1beta2_custom_metrics_k8s_io" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "apiregistration.k8s.io/v1"
    "kind" = "APIService"
    "metadata" = {
      "name" = "v1beta2.custom.metrics.k8s.io"
    }
    "spec" = {
      "group" = "custom.metrics.k8s.io"
      "groupPriorityMinimum" = 100
      "insecureSkipTLSVerify" = true
      "service" = {
        "name" = "custom-metrics-stackdriver-adapter"
        "namespace" = "custom-metrics"
      }
      "version" = "v1beta2"
      "versionPriority" = 200
    }
  }
}

resource "kubernetes_manifest" "apiservice_v1beta1_external_metrics_k8s_io" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "apiregistration.k8s.io/v1"
    "kind" = "APIService"
    "metadata" = {
      "name" = "v1beta1.external.metrics.k8s.io"
    }
    "spec" = {
      "group" = "external.metrics.k8s.io"
      "groupPriorityMinimum" = 100
      "insecureSkipTLSVerify" = true
      "service" = {
        "name" = "custom-metrics-stackdriver-adapter"
        "namespace" = "custom-metrics"
      }
      "version" = "v1beta1"
      "versionPriority" = 100
    }
  }
}

resource "kubernetes_manifest" "clusterrole_external_metrics_reader" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "external-metrics-reader"
    }
    "rules" = [
      {
        "apiGroups" = [
          "external.metrics.k8s.io",
        ]
        "resources" = [
          "*",
        ]
        "verbs" = [
          "list",
          "get",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_external_metrics_reader" {
  depends_on = [google_container_cluster.mde_gke.name]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "cluster-role-binding-auth.yaml"
    "metadata" = {
      "name" = "external-metrics-reader"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "external-metrics-reader"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "horizontal-pod-autoscaler"
        "namespace" = "kube-system"
      },
    ]
  }
}
*/