
# Create SMS notification channel
resource "google_monitoring_notification_channel" "sms" {
  display_name = var.alerts_channel
  project      = var.project_id
  type         = "sms"
  labels = {
    "channel_name" = var.alerts_channel
  }
  sensitive_labels {
    auth_token = data.google_secret_manager_secret_version.sms_token.secret_data
  }
}

# Define SMS token data source
data "google_secret_manager_secret_version" "sms_token" {
  secret  = "sms_token"
  project = var.project_id
  version = "latest"
}

# Create uptime check configuration
resource "google_monitoring_uptime_check_config" "status_code" {
  project = var.project_id
  for_each = var.monitor_urls

  display_name = "${each.value["appName"]}"
  timeout      = "10s"
  period       = "300s"
  selected_regions = ["USA_OREGON", "USA_VIRGINIA", "EUROPE", "ASIA_PACIFIC"]

  http_check {
    path           = "${each.value["path"]}"
    port           = "80"
    request_method = "GET"
  }

  monitored_resource {
    type = "uptime_url"
    
    labels = {
      project_id = var.project_id
      host       = "${each.value["url"]}"
    }
  }
}

# Create alert policy with SMS notification
resource "google_monitoring_alert_policy" "https" {
  depends_on = [google_monitoring_uptime_check_config.status_code]
  project    = var.project_id
  for_each   = var.monitor_urls
  enabled    = true

  display_name          = "${each.value["appName"]}"
  notification_channels = [google_monitoring_notification_channel.sms.name]

  combiner = "OR"

  conditions {
    display_name = "${each.value["appName"]}"

    condition_threshold {
      aggregations {
        alignment_period     = "1200s"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.*"]
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.status_code[each.key].uptime_check_id}\""
      threshold_value = "3.0"
      trigger {
        count = 1
      }
    }
  }
}
