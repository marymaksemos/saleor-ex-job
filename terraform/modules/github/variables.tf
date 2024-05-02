variable "project" {
  description = "Project to to create identity pool and service account in"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "attribute_mapping" {
  type = map(any)
  default = {
    "google.subject"       = "assertion.sub",
    "attribute.actor"      = "assertion.actor",
    "attribute.repository" = "assertion.repository"
  }
}

variable "organization" {
  type        = string
  description = "Github organization where repository exists"
}

variable "repo" {
  type        = string
  description = "Github repo where to map to service account"
}

variable "secrets" {
  type        = map(string)
  default     = {}
  description = "Create key:value secrets in github. _$ENV is added to name"
}

variable "cloudbuild_project_permissions" {
  type        = list(string)
  default     = []
  description = "Project roles to add to cloud build service account"
}

variable "service_account_project_permissions" {
  type        = list(string)
  default     = []
  description = "Project roles to add to github service account"
}

variable "allow_impersonate_sa" {
  type        = map(string)
  default     = {}
  description = "Allow github service account to impersonate given service accounts"
}

variable "create_identity_secrets" {
  type        = bool
  default     = false
  description = "Add workoad identity secrets to github repository"
}
