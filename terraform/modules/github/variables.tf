variable "project_id" {
  type        = string
  description = "Project to create identity pool and service account in"
}

variable "attribute_mapping" {
  type    = map(string)
  default = {
    "google.subject"       = "assertion.sub",
    "attribute.actor"      = "assertion.actor",
    "attribute.repository" = "assertion.repository"
  }
  description = "Attribute mappings for workload identity federation"
}

variable "repo_name" {
  type        = string
  description = "GitHub repo where to map to service account"
}

variable "secrets" {
  type        = map(string)
  default     = {}
  description = "Create key:value secrets in GitHub. _$ENV is added to name"
}

variable "cloudbuild_project_permissions" {
  type        = list(string)
  default     = []
  description = "Project roles to add to Cloud Build service account"
}

variable "service_account_project_permissions" {
  type        = list(string)
  default     = []
  description = "Project roles to add to GitHub service account"
}

variable "allow_impersonate_sa" {
  type        = map(string)
  default     = {}
  description = "Allow GitHub service account to impersonate given service accounts"
}

variable "create_identity_secrets" {
  type        = bool
  default     = false
  description = "Add workload identity secrets to GitHub repository"
}

variable "github_username" {
  type        = string
  description = "Username of the GitHub account where the repository is located"
}

variable "github_token" {
  type        = string
  description = "GitHub token for accessing GitHub API"
}
