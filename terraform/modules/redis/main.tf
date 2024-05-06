provider "google" {
  project = "saleor-lab-oyqg"
  region  = "europe-west1"
}

resource "google_redis_instance" "saleor_prod" {
  name               = "saleor-prod-redis"
  display_name       = "Saleor Production Redis"
  memory_size_gb     = 1
  redis_version      = "REDIS_6_X"
  tier               = "BASIC"
  region             = "europe-west1"
  auth_enabled       = true
 
  
  authorized_network = "saleor-network"  

  location_id        = "europe-west1-b"  

  
}


output "saleor_prod_redis_ip" {
  value     = google_redis_instance.saleor_prod.host
  sensitive = false 
}

output "saleor_prod_redis_port" {
  value     = google_redis_instance.saleor_prod.port
  sensitive = false
}

output "saleor_prod_redis_auth_string" {
  value     = google_redis_instance.saleor_prod.auth_string
  sensitive = true 
}
