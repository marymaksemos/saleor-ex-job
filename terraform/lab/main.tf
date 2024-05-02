

terraform {
  required_version = ">=1.0.0"

    backend "gcs" {
      bucket = "saleor-lab-terraform-m-state"
      prefix = "saleor-lab"
    }
}
provider "google" {

  project     = "saleor-lab-3fxv"                             
  region      = "europe-west1"
}

provider "google-beta" {
  
  project     = "saleor-lab-oyqg"                            
  region      = "europe-west1"
}

locals {
  name        = "saleor-lab"
  location    = "europe-west1"
  gce_zone    = "europe-west1-b"
  environment = "lab"
}

module "project_setup" {
  source          = "../modules/project"
  name            = local.name
  project_id      = "saleor-lab-oyqg"
  location        = local.location
  folder_id       = " "
}


