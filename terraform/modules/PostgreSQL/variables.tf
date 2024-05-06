
variable "project_id" {
  description = "The Google Cloud project ID"
}

variable "network_name" {
  description = "The network name"
}

variable "private_network" {
  description = "The full URI of the VPC network for private Google Access"
  type        = string
}
