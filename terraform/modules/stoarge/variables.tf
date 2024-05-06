variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "location" {
  description = "The location of the bucket."
  default     = "europe-west1"
}
