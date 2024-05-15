variable "project_id" {
  description = "The ID of the Google Cloud project."
}

variable "github_token" {
  description = "GitHub token for API access."
  sensitive = true
}

variable "project_number" {
  description = "The number of the Google Cloud project."
}

variable "github_pat" {
  description = "Personal Access Token for GitHub."
  sensitive = true
}

variable "app_installation_id" {
  description = "The GitHub App Installation ID."
}

variable "region" {
  description = "The region where the resources will be deployed."
  default = "global"
}

variable "name" {
  description = "The name of the Cloud Build trigger."
}

variable "location" {
  description = "The location for the Cloud Build resources."
  default = "global"
}

variable "repo_name" {
  description = "The name of the GitHub repository to build."
}

variable "vpc_network_name" {
  description = "The name of the VPC network to peer with the Cloud Build private pool"
}