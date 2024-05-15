



resource "google_container_cluster" "gke_cluster" {
  name       = var.name
  location   = var.location
  network    = var.network
  subnetwork = var.subnetwork
  initial_node_count = 1  
  enable_autopilot = true
 
  # Private cluster configuration
  # private_cluster_config {
  #   enable_private_endpoint = false 
  #   enable_private_nodes    = true   
  #   master_ipv4_cidr_block  = "172.16.0.0/28"
  #   public_endpoint_enabled = true   
  # }

  master_authorized_networks_config {
    cidr_blocks {
    display_name = "VPN Access"
    cidr_block   = "10.0.1.0/24"
    }
    cidr_blocks {
    display_name = "Home Network"
    cidr_block   = "213.89.236.167/32"
  }
    cidr_blocks {
    cidr_block   = "197.59.184.17/32" 
    display_name = "melad-network" 
            }

  }

   ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }
   deletion_protection = false

  }

