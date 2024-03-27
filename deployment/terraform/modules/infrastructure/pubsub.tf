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

// Topics/Subscriptions for change notifications on batch-ingestion bucket
resource "google_pubsub_topic" "mde_pubsub_change" {
  name   = format("%s-%s", "batch-ingestion", "change")
  labels = var.mde_deployment_labels

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_pubsub_subscription" "mde_pubsub_change_subscription" {
  name                       = format("%s-%s", google_pubsub_topic.mde_pubsub_change.name, "gcs-reader")
  topic                      = google_pubsub_topic.mde_pubsub_change.name
  message_retention_duration = "604800s" // 7 days
  retain_acked_messages      = false
  ack_deadline_seconds       = 10
  labels                     = var.mde_deployment_labels

  // Set the subscription to never expire
  expiration_policy {
    ttl = ""
  }

  lifecycle {
    prevent_destroy = true
  }
}
###########################################################################################################
// Topic/Subscriptions for the solution
resource "google_pubsub_topic" "mde_pubsub_topic" {
  for_each = var.mde_pubsub_topic_names
  name     = each.value
  labels   = var.mde_deployment_labels

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_pubsub_subscription" "mde_pubsub_subscription_dead_letter" {
  for_each                   = {for topic in var.mde_pubsub_subscriptions_dead_letter : topic.subs_name => topic}
  name                       = each.value.subs_name
  topic                      = google_pubsub_topic.mde_pubsub_topic[each.value.topic_name].name
  filter                     = each.value.filter
  message_retention_duration = "604800s" // 7 days
  retain_acked_messages      = false
  ack_deadline_seconds       = 10
  labels                     = var.mde_deployment_labels

  // Set the subscription to never expire
  expiration_policy {
    ttl = ""
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.mde_pubsub_topic[each.value.dead_letter_name].id
    max_delivery_attempts = 5
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  depends_on = [google_pubsub_subscription.mde_pubsub_subscription]
}

resource "google_pubsub_subscription" "mde_pubsub_subscription" {
  for_each                   = {for topic in var.mde_pubsub_subscriptions : topic.subs_name => topic}
  name                       = each.value.subs_name
  topic                      = google_pubsub_topic.mde_pubsub_topic[each.value.topic_name].name
  filter                     = each.value.filter
  message_retention_duration = "604800s" // 7 days
  retain_acked_messages      = false
  ack_deadline_seconds       = 10
  labels                     = var.mde_deployment_labels

  // Set the subscription to never expire
  expiration_policy {
    ttl = ""
  }
}