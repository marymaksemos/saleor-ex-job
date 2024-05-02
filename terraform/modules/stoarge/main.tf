# Create new storage bucket in the US
# location with Standard Storage

resource "google_storage_bucket" "static" {
 name          = "BUCKET_NAME"
 location      = "US"
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
}

# Upload a text file as an object
# to the storage bucket

resource "google_storage_bucket_object" "default" {
 name         = "OBJECT_NAME"
 source       = "OBJECT_PATH"
 content_type = "text/plain"
 bucket       = google_storage_bucket.static.id
}

############################################################
#########################################################
terraform {
  required_version = ">= 1.5.7"
  backend "gcs" {
    bucket = "dagens-nyheter-terraform-states"
    prefix = "static-prod"
  }
}

provider "google" {
  region = "europe-west1"
}

resource "google_storage_bucket" "dagens-nyheter-static-prod" {
  name                        = "dagens-nyheter-static-prod"
  location                    = "europe-west1"
  project                     = "infra-dagens-nyheter-f67x"
  uniform_bucket_level_access = true // https://cloud.google.com/storage/docs/uniform-bucket-level-access
  requester_pays              = false // https://cloud.google.com/storage/docs/requester-pays
  default_event_based_hold    = false // https://cloud.google.com/storage/docs/bucket-lock#default-event-based-hold

  versioning {
    enabled = true
  }
}
