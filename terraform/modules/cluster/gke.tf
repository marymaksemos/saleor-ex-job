locals {
  subnetwork_name       = "mary-gke-${var.environment}"
  network               = "projects/${local.host_project_id}/global/networks/${local.host_project_name}-vpc"
  subnetwork            = "projects/${local.host_project_id}/regions/${local.location}/subnetworks/${local.subnetwork_name}"
  
  # subnetwork_controller = "projects/${local.host_project_id}/regions/${local.location}/subnetworks/mary-gke-lab-controller"
}


# Create a GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "${var.name}-gke-cluster"
  location = var.location
  project  = var.project_id
  enable_autopilot = true


   private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.92.57.80/28"
    master_global_access_config {
      enabled = true
    }
  }

   master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.9.209.0/24"
      display_name = "VPN IT"
    }
    cidr_blocks {
      cidr_block   = "10.9.184.96/28"
      display_name = "Niteco"
    }
  }

  network    = local.network
  subnetwork = local.subnetwork

  ip_allocation_policy {
      cluster_secondary_range_name  = "${local.subnetwork_name}-pods"
      services_secondary_range_name = "${local.subnetwork_name}-services"
    }
  
   depends_on = [
    google_compute_subnetwork_iam_member.container_subnet_user,
    google_compute_subnetwork_iam_member.cloudservices_subnet_user,
    google_project_iam_member.host_agent
  ]


}



resource "google_artifact_registry_repository_iam_member" "compute_repository_member" {
  project    = local.infra_project_id
  location   = local.location
  repository = var.department
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${731320965456}-compute@developer.gserviceaccount.com"
  # depends_on = [
  #   google_project_service.project_services,
  # ]
}

resource "google_compute_subnetwork_iam_member" "container_subnet_user" {
  subnetwork = local.subnetwork_name
  role       = "roles/compute.networkUser"
  region     = local.location
  project    = local.host_project_id
  member     = "serviceAccount:${local.container_service_account}"
  # depends_on = [
  #   google_project_service.project_services
  # ]
}



resource "google_compute_subnetwork_iam_member" "cloudservices_subnet_user" {
  subnetwork = local.subnetwork_name
  role       = "roles/compute.networkUser"
  region     = local.location
  project    = local.host_project_id
  member     = "serviceAccount:${local.cloudservices_service_account}"
  # depends_on = [
  #   google_project_service.project_services
  # ]
}

resource "google_project_iam_member" "host_agent" {
  project = local.host_project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:${local.container_service_account}"
  # depends_on = [
  #   google_project_service.project_services
  # ]
}

data "google_client_config" "provider" {
}

provider "kubernetes" {
  host  = "https://${google_container_cluster.gke_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  )
}


resource "kubernetes_namespace" "test_namespace" {
  metadata {
    annotations = {
      name = "test"
    }

    name = "test"
  }
}
#   # Define the node pool configuration
#   remove_default_node_pool = true
#   initial_node_count       = 1

#   # Define the master authorized network configuration if needed
#   # master_authorized_networks_config {
#   #   cidr_blocks {
#   #     cidr_block   = "authorized-cidr-block"#add your authorized
#   #     display_name = "display-name"# add your display name
#   #   }
#   # }

  
# }

# # Define a node pool for the GKE cluster
# resource "google_container_node_pool" "primary_nodes" {
#   name       = "${var.name}-gke-node-pool"
#   location   = var.location
#   cluster    = google_container_cluster.gke_cluster.name
#   project    = var.project_id
#   node_count = 1

#   node_config {
#     machine_type = "e2-small"
#     disk_size_gb = 20

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/compute",
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring"
#     ]
#   }
# }