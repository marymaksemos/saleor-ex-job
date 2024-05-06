

resource "random_string" "project_suffix" {
  length  = 4
  upper   = false
  special = false
}

# Create a GCP project. 
resource "google_project" "project" {
  name       = var.name
  project_id = "${var.name}-${random_string.project_suffix.result}"
  billing_account     = "01597B-C35ADE-A1B54D"
  auto_create_network = false

}




resource "google_project_service" "gke_service" {
   project = google_project.project.project_id
   service = "container.googleapis.com"  # Service name for Google Kubernetes Engine

   disable_on_destroy = false
 }


# Enable the Artifact Registry API for the project.
resource "google_project_service" "artifact_registry" {
  service = "artifactregistry.googleapis.com"
  project = google_project.project.project_id
}



# Create a repository in Artifact Registry in which we can store our images for deployment.
resource "google_artifact_registry_repository" "repo" {
  provider      = google-beta
  project       = google_project.project.project_id
  location      = var.location
  repository_id = "images"
  format        = "DOCKER"
  depends_on = [
     google_project_service.artifact_registry
  ]
}

# Enable the Cloud Build API for the project.
resource "google_project_service" "cloudbuild_api" {
  service = "cloudbuild.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  project = google_project.project.project_id
}


# When building containers using Cloud Build it will automatically create a storage bucket for itself.
resource "google_storage_bucket" "cloud_build_bucket" {
  name                        = "${google_project.project.project_id}-cloudbuild"
  location                    = var.location
  project                     = google_project.project.project_id
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "terraform_state" {
  name          = "${var.name}-terraform-m-state"
  location      = var.location
  project       = google_project.project.project_id
  storage_class = "REGIONAL"
}

# Give the default Cloud Build SA the role artifactregistry.admin.
resource "google_project_iam_binding" "artifactory_admin" {
  project = google_project.project.project_id
  role    = "roles/artifactregistry.admin"
  members = [
    "serviceAccount:${google_project.project.number}@cloudbuild.gserviceaccount.com",
  ]
}

# Creates a custom role for listing buckets.
resource "google_project_iam_custom_role" "bucket_viewer" {
  project     = google_project.project.project_id
  role_id     = "bucket_viewer"
  title       = "Bucket Viewer"
  description = "Role for sa to list buckets. Required for Cloud Build to read logs"
  permissions = ["storage.buckets.list"]
}



# Gives the github identity SA and Cloudbuild SA storage admin role
# but with a condition to two specific buckets that are created by
# the module "cloudrun_build". This combined with the permission
# above gives these accounts only the nessasary permissions to
# the buckets.
resource "google_project_iam_binding" "storage_admin" {
  project = google_project.project.project_id
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_project.project.number}@cloudbuild.gserviceaccount.com"
  ]
  condition {
    title       = "Cloudbuild bucket admin"
    description = "Enable github build user to store temporary artifacts and logs."
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_project.project.project_id}-cloudbuild\")"
  }
}


# Gives the github identity SA and Cloudbuild SA the role bucket_viewer.
resource "google_project_iam_binding" "viewer" {
  project = google_project.project.project_id
  role    = "projects/${google_project.project.project_id}/roles/bucket_viewer"
  members = [
    "serviceAccount:${google_project.project.number}@cloudbuild.gserviceaccount.com"
  ]
}

resource "google_project_service" "secret_manager" {
  service = "secretmanager.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "cloud_asset" {
  service = "cloudasset.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "cloud_billing" {
  service = "cloudbilling.googleapis.com"
  project = google_project.project.project_id
}


resource "google_project_service" "monitoring" {
  service = "monitoring.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "dns" {
  service = "dns.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "iap" {
  service = "iap.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "iam_credentials" {
  service = "iamcredentials.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "cloud_build" {
  service = "cloudbuild.googleapis.com"
  project = google_project.project.project_id
}
resource "google_project_service" "redis" {
  service = "redis.googleapis.com"
   project = google_project.project.project_id
}

resource "google_project_service" "service_networking" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}
