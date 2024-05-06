output "vpc_network_id" {
  value = google_compute_network.vpc_network.id
}

output "subnet_ids" {
  value = { for s in google_compute_subnetwork.vpc_subnetwork : s.name => s.id }
}
output "private_network_uri" {
  value = google_compute_global_address.private_ip_range.network
}
output "subnetwork_secondary_ranges" {
  value = {
    for subnet_key, subnet in google_compute_subnetwork.vpc_subnetwork : 
      subnet_key => {
        pods_range      = length(subnet.secondary_ip_range) > 0 ? subnet.secondary_ip_range[0].ip_cidr_range : ""
        services_range  = length(subnet.secondary_ip_range) > 1 ? subnet.secondary_ip_range[1].ip_cidr_range : ""
      }
  }
  description = "Map of subnetwork keys to their secondary IP ranges for pods and services."
}

output "network_self_link" {
  value = google_compute_network.vpc_network.self_link
  description = "The self link of the VPC network."
}

output "subnetwork_self_links" {
  value = { for k, v in google_compute_subnetwork.vpc_subnetwork : k => v.self_link }
  description = "A map of all subnetwork self-links."
}

