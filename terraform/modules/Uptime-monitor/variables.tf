
variable "alerts_channel" {
  description = "The display name for the monitoring notification channel"
  type        = string
}

variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
}

variable "notification_channels" {
  description = "A list of email addresses where notifications will be sent"
  type        = list(string)
}

variable "monitor_urls" {
  description = "A map of monitor URLs with their configurations"
  type        = map(object({
    appName = string
    path    = string
    url     = string
  }))
}
