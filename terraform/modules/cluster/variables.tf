variable "environment" {
  type = string
}

variable "department" {
  type = string
}
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