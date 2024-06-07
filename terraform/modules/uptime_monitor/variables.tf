variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "alerts_channel" {
  description = "The name of the alerts channel."
  type        = string
}

variable "monitor_urls" {
  description = "A map containing the URLs and app names to monitor."
  type        = map(object({
    url   : string
    path  : string
    appName : string
  }))
}

variable "phone_number" {
  description = "The phone number for receiving SMS notifications."
  type        = string
}
