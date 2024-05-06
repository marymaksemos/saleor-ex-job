resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false 
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  for_each             = var.subnets
  name                 = each.value.name
  ip_cidr_range        = each.value.cidr
  region               = each.value.region
  network              = google_compute_network.vpc_network.self_link
  private_ip_google_access = true
}

resource "google_compute_firewall" "vpc_firewall" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = var.subnets_cidrs
}

resource "google_compute_firewall" "ssh_and_rdp" {
  name    = "${var.network_name}-ssh-rdp"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  
   source_ranges = ["213.89.236.167/32"]
  target_tags   = ["ssh-access"]
}


# Reserve IP range for services
resource "google_compute_global_address" "private_ip_range" {
  name          = "${var.network_name}-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.vpc_network.self_link
}



resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]

  depends_on = [
    google_project_service.service_networking,
    google_compute_global_address.private_ip_range
  ]
}
resource "google_project_service" "service_networking" {
  service = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}
resource "google_compute_subnetwork" "subnet_er" {
  name                     = "subnet-er"
  network                  = "projects/${var.project_id}/global/networks/saleor-network"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = "europe-west1"
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.0.2.0/24"
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.0.3.0/24"
  }
}
