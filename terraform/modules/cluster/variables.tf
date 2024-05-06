


variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "project_id" {
  description = "The project ID where the GKE cluster will be created"
  type        = string
}

# variable "subnet_controll" {
#   type = string
# }

variable "network" {
  description = "The self link of the VPC network"
  type        = string
}

variable "subnetwork" {
  description = "The self link of the subnetwork"
  type        = string
}

variable "pods_range" {
  description = "CIDR for the pods secondary IP range"
  type        = string
}

variable "services_range" {
  description = "CIDR for the services secondary IP range"
  type        = string
}
