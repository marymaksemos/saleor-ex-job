/**
 * # Bonniernews GCP Github terraform module
 *
 * This module allows you to create an service account to work as workload identity for a github repo to interact with specified project.
 * 
 */
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Enable iam credentials in project to be able to create workload identities
resource "google_project_service" "iam_credentials" {
  project            = var.project.project_id
  disable_on_destroy = false
  service            = "iamcredentials.googleapis.com"
}

# This service account will be used by github to interact with GCP
resource "google_service_account" "github_identity" {
  account_id   = "github-identity"
  display_name = "Workload identity for github"
  project      = var.project.project_id
}

resource "google_service_account_iam_member" "impersonate_service_accounts" {
  for_each           = var.allow_impersonate_sa
  service_account_id = "projects/${var.project.project_id}/serviceAccounts/${each.value}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${var.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_iam_workload_identity_pool" "github_identity" {
  provider                  = google-beta
  workload_identity_pool_id = "github-identity-pool"
  project                   = var.project.project_id
}

resource "google_iam_workload_identity_pool_provider" "github_identity" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_identity.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-identity-provider"
  project                            = var.project.project_id
  attribute_mapping                  = var.attribute_mapping

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Allow specified github repo to impersonate created service account
resource "google_service_account_iam_binding" "github_identity_user" {
  service_account_id = google_service_account.github_identity.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_identity.name}/attribute.repository/${var.organization}/${var.repo}",
  ]
}

# By default, we allow service account and cloud build user to write to cloudbuild bucket
resource "google_storage_bucket_iam_binding" "cloudbuild_storage_admin" {
  bucket = "${var.project.project_id}_cloudbuild"
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.github_identity.email}",
    "serviceAccount:${var.project.number}@cloudbuild.gserviceaccount.com"
  ]
}

locals {
  default_sa_permissions = ["roles/cloudbuild.builds.builder",
    "roles/iam.serviceAccountUser",
    "roles/run.developer",
  ]

  default_cloudbuild_permissions = ["roles/artifactregistry.admin",
    "roles/storage.admin"
  ]
}

# Give service account project permissions specified by service_account_project_permissions
resource "google_project_iam_member" "service_account_permissions" {
  for_each = toset(concat(var.service_account_project_permissions, local.default_sa_permissions))
  project  = var.project.project_id
  role     = each.value

  member = "serviceAccount:${google_service_account.github_identity.email}"
}

# Give cloudbuild account project permissions specified by cloudbuild_project_permissions
resource "google_project_iam_member" "cloudbuild_permissions" {
  for_each = toset(concat(var.cloudbuild_project_permissions, local.default_cloudbuild_permissions))
  project  = var.project.project_id
  role     = each.value

  member = "serviceAccount:${var.project.number}@cloudbuild.gserviceaccount.com"
}

# If enabled, create github action secret in github
resource "github_actions_secret" "service_account" {
  count           = var.create_identity_secrets ? 1 : 0
  repository      = var.repo
  secret_name     = "GCP_SERVICE_ACCOUNT_${upper(var.environment)}"
  plaintext_value = google_service_account.github_identity.email
}

# If enabled, create github action secret in github
resource "github_actions_secret" "project_id" {
  count           = var.create_identity_secrets ? 1 : 0
  repository      = var.repo
  secret_name     = "GCP_PROJECT_ID_${upper(var.environment)}"
  plaintext_value = var.project.project_id
}

# If enabled, create github action secret in github
resource "github_actions_secret" "provider_id" {
  count           = var.create_identity_secrets ? 1 : 0
  repository      = var.repo
  secret_name     = "GCP_PROVIDER_ID_${upper(var.environment)}"
  plaintext_value = google_iam_workload_identity_pool_provider.github_identity.name
}

resource "github_actions_secret" "secrets" {
  for_each        = var.secrets
  repository      = var.repo
  secret_name     = "${each.key}_${upper(var.environment)}"
  plaintext_value = each.value
}
