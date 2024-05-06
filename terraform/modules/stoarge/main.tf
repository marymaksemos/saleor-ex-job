
resource "google_storage_bucket" "saleor_storage" {
  name                        = var.bucket_name
  location                    = var.location
  project                     = var.project_id
  uniform_bucket_level_access = true
  requester_pays              = false
  default_event_based_hold    = false

  versioning {
    enabled = true
  }
}