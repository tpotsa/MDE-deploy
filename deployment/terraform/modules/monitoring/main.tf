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

# There's a bug in the terraform component that always marks the dashboard as tainted, there's a workaround here:
# https://github.com/hashicorp/terraform-provider-google/issues/7242#issuecomment-1515468025
# until it's fixed in v 5.
resource "google_monitoring_dashboard" "dashboard" {
  lifecycle {
    ignore_changes = [dashboard_json]
  }
  dashboard_json = <<EOF
{
  "displayName": "MDE Monitoring",
  "mosaicLayout": {
    "columns": 48,
    "tiles": [
      {
        "yPos": 4,
        "width": 13,
        "height": 12,
        "widget": {
          "title": "input-messages",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\" metadata.system_labels.\"name\"=\"input-messages\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 22,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "Message Mapper",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"message-mapping-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 8,
        "yPos": 22,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "Config Manager",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"configuration-processing-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 16,
        "yPos": 22,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "Metadata Manager",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"metadata-processing-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 24,
        "yPos": 22,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "BQ Sink",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"bigquery-sink-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 40,
        "yPos": 22,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "GCS Raw Writer",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"df-gcs-raw-ingester\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 8,
        "yPos": 30,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "BigTable Writer",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"bigtable-writer-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 30,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "GCS Processed Writer",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"gcs-writer-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 32,
        "yPos": 22,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "PubSubSink",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"pubsub-sink-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 16,
        "yPos": 30,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "Event Change Transform",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"event-change-transformation-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 16,
        "width": 48,
        "height": 6,
        "widget": {
          "title": "Unacked messages in PubSub Subscriptions",
          "text": {
            "content": "- A low number means the messages are being ingested swiftly by their corresponding processing step.\n- If one of these numbers starts growing it is advisable to check the corresponding processing step.",
            "format": "MARKDOWN"
          }
        }
      },
      {
        "width": 48,
        "height": 4,
        "widget": {
          "title": "Data Throughput Pubsub",
          "text": {
            "format": "MARKDOWN"
          }
        }
      },
      {
        "xPos": 13,
        "yPos": 4,
        "width": 12,
        "height": 12,
        "widget": {
          "title": "message-mapping-processed",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\" metadata.system_labels.\"name\"=\"message-mapping-processed\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 25,
        "yPos": 4,
        "width": 11,
        "height": 12,
        "widget": {
          "title": "configuration-processed",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\" metadata.system_labels.\"name\"=\"configuration-processed\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 36,
        "yPos": 4,
        "width": 12,
        "height": 12,
        "widget": {
          "title": "metadata-processed",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\" metadata.system_labels.\"name\"=\"metadata-processed\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 38,
        "width": 48,
        "height": 4,
        "widget": {
          "title": "Services Scaling - CPUs",
          "text": {
            "format": "RAW"
          }
        }
      },
      {
        "yPos": 42,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "Message Mapper",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"kubernetes.io/container/cpu/request_cores\" resource.type=\"k8s_container\" metadata.system_labels.\"top_level_controller_name\"=\"message-mapper\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_SUM"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 10,
        "yPos": 42,
        "width": 9,
        "height": 12,
        "widget": {
          "title": "Configuration Manager",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"kubernetes.io/container/cpu/request_cores\" resource.type=\"k8s_container\" metadata.system_labels.\"top_level_controller_name\"=\"configuration-manager\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_SUM"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 19,
        "yPos": 42,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "Metadata Manager",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"kubernetes.io/container/cpu/request_cores\" resource.type=\"k8s_container\" metadata.system_labels.\"top_level_controller_name\"=\"metadata-manager\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_SUM"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 29,
        "yPos": 42,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "BQ Sink",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"kubernetes.io/container/cpu/request_cores\" resource.type=\"k8s_container\" metadata.system_labels.\"top_level_controller_name\"=\"bigquery-sink\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_SUM"
                    },
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 24,
        "yPos": 86,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "GKE Services Latency 95th percentile",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/metadata/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_95"
                    }
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "metadata",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y2"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/mapper/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_95"
                    }
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "mapper",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y2"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/configuration/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_95"
                    }
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "config",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y2"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/sink/bq/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_95"
                    }
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "sink",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y2"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/sink/pubsub/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_50"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            },
            "y2Axis": {
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "xPos": 24,
        "yPos": 30,
        "width": 8,
        "height": 8,
        "widget": {
          "title": "Window Transform",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" metadata.system_labels.\"name\"=\"window-transformation-subscription\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 39,
        "yPos": 42,
        "width": 9,
        "height": 12,
        "widget": {
          "title": "PubSub Sink",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"kubernetes.io/container/cpu/request_cores\" resource.type=\"k8s_container\" metadata.system_labels.\"top_level_controller_name\"=\"pubsub-sink\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_SUM"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 70,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "Message Mapper",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesQueryLanguage": "fetch global\n| metric 'custom.googleapis.com/mde/mapper/messages/count/count'\n| group_by 1m, [value_count_mean: mean(value.count)]\n| every 1m\n| group_by [resource.project_id],\n    [value_count_mean_aggregate: aggregate(value_count_mean) / 60]"
                },
                "plotType": "LINE",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 66,
        "width": 48,
        "height": 4,
        "widget": {
          "title": "Services Throughput",
          "text": {
            "format": "RAW"
          }
        }
      },
      {
        "xPos": 10,
        "yPos": 70,
        "width": 9,
        "height": 12,
        "widget": {
          "title": "Configuration Manager Throughput",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesQueryLanguage": "fetch global\n| metric 'custom.googleapis.com/mde/configuration/messages/count/count'\n| group_by 1m, [value_count_mean: mean(value.count)]\n| every 1m\n| group_by [resource.project_id],\n    [value_count_mean_aggregate: aggregate(value_count_mean) / 60]"
                },
                "plotType": "LINE",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 19,
        "yPos": 70,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "Metadata Manager Throughput",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesQueryLanguage": "fetch global\n| metric 'custom.googleapis.com/mde/metadata/messages/count/count'\n| group_by 1m, [value_count_mean: mean(value.count)]\n| every 1m\n| group_by [resource.project_id],\n    [value_count_mean_aggregate: aggregate(value_count_mean) / 60]"
                },
                "plotType": "LINE",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 29,
        "yPos": 70,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "BQ Sink Throughput",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesQueryLanguage": "fetch global\n| metric 'custom.googleapis.com/mde/sink/bq/messages/count/count'\n| group_by 1m, [value_count_mean: mean(value.count)]\n| every 1m\n| group_by [resource.project_id],\n    [value_count_mean_aggregate: aggregate(value_count_mean) / 60]"
                },
                "plotType": "LINE",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 39,
        "yPos": 70,
        "width": 9,
        "height": 12,
        "widget": {
          "title": "PubSub Sink Throughput",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesQueryLanguage": "fetch global\n| metric 'custom.googleapis.com/mde/sink/pubsub/messages/count/count'\n| group_by 1m, [value_count_mean: mean(value.count)]\n| every 1m\n| group_by [resource.project_id],\n    [value_count_mean_aggregate: aggregate(value_count_mean) / 60]"
                },
                "plotType": "LINE",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 86,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "GKE Services Latency 50th percentile",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/metadata/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_50"
                    }
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "metadata",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y2"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/mapper/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_50"
                    }
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "mapper",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y2"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/configuration/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_50"
                    }
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "config",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y2"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/sink/bq/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_50"
                    }
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "sink",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y2"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"custom.googleapis.com/mde/sink/pubsub/processing/time\" resource.type=\"global\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_50"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            },
            "y2Axis": {
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 82,
        "width": 48,
        "height": 4,
        "widget": {
          "title": "Services Processing Latency",
          "text": {
            "format": "RAW"
          }
        }
      },
      {
        "yPos": 54,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "GCSWriter",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"dataflow.googleapis.com/job/current_num_vcpus\" resource.type=\"dataflow_job\" resource.label.\"job_name\"=monitoring.regex.full_match(\"gcs-writer.*\")",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 10,
        "yPos": 54,
        "width": 9,
        "height": 12,
        "widget": {
          "title": "BigTable Writer",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"dataflow.googleapis.com/job/current_num_vcpus\" resource.type=\"dataflow_job\" resource.label.\"job_name\"=monitoring.regex.full_match(\"bigtable-writer.*\")",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 19,
        "yPos": 54,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "Event Change Transform",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"dataflow.googleapis.com/job/current_num_vcpus\" resource.type=\"dataflow_job\" resource.label.\"job_name\"=monitoring.regex.full_match(\"event-change.*\")",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 29,
        "yPos": 54,
        "width": 10,
        "height": 12,
        "widget": {
          "title": "Window Transform",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"dataflow.googleapis.com/job/current_num_vcpus\" resource.type=\"dataflow_job\" resource.label.\"job_name\"=monitoring.regex.full_match(\"window.*\")",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 39,
        "yPos": 54,
        "width": 9,
        "height": 12,
        "widget": {
          "title": "GCS Reader",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"dataflow.googleapis.com/job/current_num_vcpus\" resource.type=\"dataflow_job\" resource.label.\"job_name\"=monitoring.regex.full_match(\"gcs-reader.*\")",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      }
    ]
  }
}

EOF
}