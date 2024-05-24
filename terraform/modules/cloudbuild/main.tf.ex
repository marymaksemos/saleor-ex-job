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
  token = var.github_token
}

resource "google_secret_manager_secret" "github_token_secret" {
  project = var.project_id
  secret_id = "github-token"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}


resource "google_secret_manager_secret_version" "github_token_secret_version" {
  secret = google_secret_manager_secret.github_token_secret.id
  secret_data = var.github_pat
}

data "google_iam_policy" "serviceagent_secret_accessor" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
    ]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project = var.project_id
  secret_id = google_secret_manager_secret.github_token_secret.id
  policy_data = data.google_iam_policy.serviceagent_secret_accessor.policy_data
}

resource "google_project_iam_member" "cloudbuild_k8s_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_k8s_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_cloudbuildv2_connection" "github_connection" {
  project = var.project_id
  location = var.region
  name = "github-connection"

  github_config {
    app_installation_id = var.app_installation_id
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token_secret_version.id
    }
  }
  depends_on = [google_secret_manager_secret_iam_policy.policy]
}
resource "google_pubsub_topic" "artifact_registry_topic" {
  name = "artifact-registry-topic"
}

resource "google_pubsub_topic_iam_binding" "cloud_build_publisher_binding" {
  topic = google_pubsub_topic.artifact_registry_topic.name
  role  = "roles/pubsub.publisher"

  members = [
    "serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
  ]
}
resource "google_cloudbuild_trigger" "github_trigger" {
  name = "saleor-trigger"
  location = var.region
  project = var.project_id
  description = "Trigger for GitHub repo changes"
  github {
    owner = "marymaksemos"
    name = "saleor-ex-job"
    push {
      branch = "^main$"
    }
  }
  filename = "cloudbuild.yaml"
  depends_on = [google_cloudbuildv2_connection.github_connection]
}

