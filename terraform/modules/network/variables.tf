variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "A map of subnets to create within the VPC"
  type = map(object({
    name   : string
    cidr   : string
    region : string
  }))
}

variable "subnets_cidrs" {
  description = "List of CIDR blocks for the subnets to allow internal communication"
  type        = list(string)
}
variable "project_id" {
  description = "The project ID where the GKE cluster will be created"
  type        = string
}

variable "router_region" {
  description = "Region for the Cloud Router and Cloud NAT"
  default     = "europe-west1"
}