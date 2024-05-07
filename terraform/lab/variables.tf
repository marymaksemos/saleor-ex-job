variable "github_token" {
  description = "GitHub API token used for GitHub integration"
  type        = string
}
variable "project_id" {
  description = "The project ID in Google Cloud"
}


variable "project_number" {
  description = "The project number in Google Cloud"
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
}

variable "app_installation_id" {
  description = "GitHub App Installation ID"
}

variable "region" {
  description = "Region for Google Cloud resources"
  default     = "europe-west1"
}

variable "name" {
  description = "Name of the resource"
  default     = "saleor-lab"
}

variable "repo_name" {
  description = "Name of the GitHub repository"
  default     = "saleor-ex-job"
}

variable "network_name" {
  description = "Name of the network in Google Cloud"
  default     = "saleor-network"
}

