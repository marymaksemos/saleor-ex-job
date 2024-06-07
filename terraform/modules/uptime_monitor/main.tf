
# Resource: SMS Notification Channel
resource "google_monitoring_notification_channel" "sms" {
  display_name = var.alerts_channel
  project      = var.project_id
  type         = "sms"
  labels = {
    number = var.phone_number  # Ensure you add `phone_number` variable with a valid phone number
  }
}

# Resource: Uptime Check Configuration
resource "google_monitoring_uptime_check_config" "status_code" {
  project   = var.project_id
  for_each  = var.monitor_urls

  display_name     = each.value.appName
  timeout          = "10s"
  period           = "300s"
  selected_regions = ["USA_OREGON", "USA_VIRGINIA", "EUROPE", "ASIA_PACIFIC"]

  http_check {
    path           = each.value.path
    port           = 80
    request_method = "GET"
    use_ssl        = true 
  }

  monitored_resource {
    type   = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = each.value.url  
    }
  }
}

# Resource: Alert Policy
resource "google_monitoring_alert_policy" "https" {
  depends_on = [google_monitoring_uptime_check_config.status_code]
  project    = var.project_id
  for_each   = var.monitor_urls
  enabled    = true

  display_name          = each.value.appName
  notification_channels = [google_monitoring_notification_channel.sms.id]

  combiner = "OR"
  conditions {
    display_name = each.value.appName

    condition_threshold {
      filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.status_code[each.key].id}\""
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      threshold_value = 3.0

      aggregations {
        alignment_period     = "1200s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.*"]
      }

      trigger {
        count = 1
      }
    }
  }
}
