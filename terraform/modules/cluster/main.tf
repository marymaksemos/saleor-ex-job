terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

provider "google" {
  region = "europe-west1"
}

provider "helm" {
  kubernetes {
    host  = "https://${google_container_cluster.cluster.endpoint}"
    token = data.google_client_config.provider.access_token
     cluster_ca_certificate = base64decode(
     google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}

locals {
  name              = "mary-non-prod"
  location          = "europe-west1"
  infra_project_id  = "infra-${var.department}-f67x"
  host_project_name = "bn-infra"
  host_project_id   = "${local.host_project_name}-9a5e"
  container_service_account     = "service-${731320965456}@container-engine-robot.iam.gserviceaccount.com"
  cloudservices_service_account = "${731320965456}@cloudservices.gserviceaccount.com"
}


