

    terraform {
      required_version = ">=1.0.0"

        backend "gcs" {
          bucket = "saleor-lab-terraform-m-state"
          prefix = "saleor-lab"
        }
    }
    provider "google" {

      project     = var.project_id                            
      region      = var.region
    }

    provider "google-beta" {
      
     project     = var.project_id                            
      region      = var.region
      
    }

    locals {
      name        = "saleor-lab"
      gce_zone    = "europe-west1-b"
      environment = "lab"
      github_username= "marymaksemos"

    }

    module "project_setup" {
      source          = "../modules/project"
      name            = local.name
      project_id      = var.project_id
      location        = var.region
    }


    module "github_integration" {
      source = "../modules/github"
      repo_name            = var.repo_name
      project_id           = var.project_id
      github_token         = var.github_token
      github_username      = local.github_username
    
    }


    module "saleor_storage_prod" {
      source     = "../modules/stoarge"
      bucket_name = "saleor-storage-prod"
      project_id  = var.project_id
    }

  module "network" {
  source       = "../modules/network"
  network_name = var.network_name
  project_id   = var.project_id
  subnets      = {
    "europe-west1" = {
      name   = "subnet-er"
      cidr   = "10.0.1.0/24"
      region = "europe-west1"
    }
  }
  subnets_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
}


    module "redis_instance" {
      source         = "../modules/redis"
    
    }
    module "postgres_db" {
      source = "../modules/PostgreSQL"
      project_id           = var.project_id
      network_name = var.network_name
      private_network = module.network.private_network_uri
    }

module "cluster-saleor" {
  source        = "../modules/cluster"
  name          = "saleor-cluster"
  location      = var.region
  project_id    = var.project_id
  network       = module.network.network_self_link
  subnetwork    = module.network.subnetwork_self_links["europe-west1"]
  pods_range    = module.network.subnetwork_secondary_ranges["europe-west1"].pods_range
  services_range = module.network.subnetwork_secondary_ranges["europe-west1"].services_range
}

module "github_cloud_build" {
  source = "../modules/cloudbuild"

 project_id          = var.project_id
  github_token        = var.github_token
  project_number      = var.project_number
  github_pat          = var.github_pat
  app_installation_id = var.app_installation_id
  region              = var.region
  name                = "github-trigger"
  location            = "global"
  repo_name           = "saleor-ex-job"
}
