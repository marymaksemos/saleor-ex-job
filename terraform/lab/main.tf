

    terraform {
      required_version = ">=1.0.0"

        backend "gcs" {
          bucket = "saleor-lab-terraform-m-state"
          prefix = "saleor-lab"
        }
    }
    provider "google" {

      project     = "saleor-lab-oyqg"                             
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
      github_username= "marymaksemos"

    }

    module "project_setup" {
      source          = "../modules/project"
      name            = local.name
      project_id      = "saleor-lab-oyqg"
      location        = local.location
    }


    module "github_integration" {
      source = "../modules/github"
      repo_name            = "saleor-ex-job"
      project_id           = "saleor-lab-oyqg"
      github_token         = var.github_token
      github_username      = local.github_username
    
    }


    module "saleor_storage_prod" {
      source     = "../modules/stoarge"
      bucket_name = "saleor-storage-prod"
      project_id  = "saleor-lab-oyqg"
    }

  module "network" {
  source       = "../modules/network"
  network_name = "saleor-network"
  project_id   = "saleor-lab-oyqg"
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
      project_id           = "saleor-lab-oyqg"
      network_name = "saleor-network"
      private_network = module.network.private_network_uri
    }

module "cluster-saleor" {
  source        = "../modules/cluster"
  name          = "saleor-cluster"
  location      = "europe-west1"
  project_id    = "saleor-lab-oyqg"
  network       = module.network.network_self_link
  subnetwork    = module.network.subnetwork_self_links["europe-west1"]
  pods_range    = module.network.subnetwork_secondary_ranges["europe-west1"].pods_range
  services_range = module.network.subnetwork_secondary_ranges["europe-west1"].services_range
}

