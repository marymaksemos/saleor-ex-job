terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.26"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.26"
    }
  }
}

provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

provider "github" {
  token        = var.github_token
  owner        = var.github_username
}

resource "google_project_service" "iam_credentials" {
  project = var.project_id
  service = "iamcredentials.googleapis.com"
}

resource "google_service_account" "github_identity" {
  account_id   = "github-identity"
  display_name = "Workload Identity for GitHub"
  project      = var.project_id
}

resource "google_iam_workload_identity_pool" "github_identity" {
  provider                  = google-beta
  workload_identity_pool_id = "github-identity-pool"
  project                   = var.project_id
}


resource "google_iam_workload_identity_pool_provider" "github_identity" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_identity.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-identity-provider"
  project                            = var.project_id

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}


resource "google_service_account_iam_binding" "github_identity_user" {
  service_account_id = google_service_account.github_identity.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_identity.name}/attribute.repository/${var.github_username}/${var.repo_name}",
  ]
}

resource "google_storage_bucket_iam_binding" "cloudbuild_storage_admin" {
  bucket  = "${var.project_id}-cloudbuild"
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.github_identity.email}",
  ]
}

resource "google_project_iam_member" "service_account_permissions" {
  for_each = toset([
    "roles/cloudbuild.builds.builder",
    "roles/iam.serviceAccountUser",
    "roles/run.developer"
  ])
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.github_identity.email}"
}

resource "github_actions_secret" "gcp_service_account_email" {
  repository      = var.repo_name
  secret_name     = "GCP_SERVICE_ACCOUNT_EMAIL"
  plaintext_value = google_service_account.github_identity.email
}

resource "github_actions_secret" "gcp_project_id" {
  repository      = var.repo_name
  secret_name     = "GCP_PROJECT_ID"
  plaintext_value = var.project_id
}

resource "google_project_iam_member" "cloud_build_editor" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${google_service_account.github_identity.email}"
}

resource "google_project_iam_member" "cloud_build_admin" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"  
  member  = "serviceAccount:${google_service_account.github_identity.email}"
}

# Grant the service account permissions to read objects from all buckets in the project
resource "google_project_iam_member" "storage_object_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.github_identity.email}"
}

# Grant the service account permissions to create and overwrite objects in all buckets in the project
resource "google_project_iam_member" "storage_object_creator" {
  project = var.project_id
  role    = "roles/storage.objectCreator"
  member  = "serviceAccount:${google_service_account.github_identity.email}"
}



