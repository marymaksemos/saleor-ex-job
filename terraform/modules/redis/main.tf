resource "google_redis_instance" "my_memorystore_redis_instance" {
  name           = "myinstance"
  tier           = "BASIC"
  memory_size_gb = 2
  region         = "us-central1"
  redis_version  = "REDIS_6_X"
}

output "host" {
 description = "The IP address of the instance."
 value = "${google_redis_instance.my_memorystore_redis_instance.host}"
}


#################################################3333333
##########################################################
terraform {
  required_version = ">= 1.4.6"
  backend "gcs" {
    bucket = "dagens-nyheter-terraform-states"
    prefix = "redis-prod"
  }
}

provider "google" {
  project = "infra-dagens-nyheter-f67x"
  region  = "europe-west1"
}

# https://console.cloud.google.com/memorystore/redis/locations/europe-west1/instances/newsletter-prod/details/overview?project=infra-dagens-nyheter-f67x
resource "google_redis_instance" "newsletter_prod" {
  auth_enabled       = true
  authorized_network = "projects/bn-infra-9a5e/global/networks/bn-infra-vpc"
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  name               = "newsletter-prod"
  display_name       = "newsletter-prod redis"
  memory_size_gb     = 1
  redis_version      = "REDIS_6_X"
  tier               = "STANDARD_HA"
}

resource "google_dns_record_set" "dn_redis_newsletter_prod" {
  name         = "redis-newsletter-prod.dn.bn.nr."
  type         = "A"
  ttl          = 300
  managed_zone = "bnnr"
  rrdatas      = [google_redis_instance.newsletter_prod.host]
}

# terraform output -raw newsletter_prod_auth_string
output "newsletter_prod_auth_string" {
  value     = google_redis_instance.newsletter_prod.auth_string
  sensitive = true
}

# https://console.cloud.google.com/memorystore/redis/locations/europe-west1/instances/user-prod/details/overview?project=infra-dagens-nyheter-f67x
resource "google_redis_instance" "user_prod" {
  auth_enabled       = true
  authorized_network = "projects/bn-infra-9a5e/global/networks/bn-infra-vpc"
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  name               = "user-prod"
  display_name       = "user-prod redis"
  memory_size_gb     = 2
  redis_version      = "REDIS_6_X"
  tier               = "STANDARD_HA"
}

resource "google_dns_record_set" "dn_redis_user_prod" {
  name         = "redis-user-prod.dn.bn.nr."
  type         = "A"
  ttl          = 300
  managed_zone = "bnnr"
  rrdatas      = [google_redis_instance.user_prod.host]
}

# terraform output -raw user_prod_auth_string
output "user_prod_auth_string" {
  value     = google_redis_instance.user_prod.auth_string
  sensitive = true
}

# https://console.cloud.google.com/memorystore/redis/locations/europe-west1/instances/push-prod/details/overview?project=infra-dagens-nyheter-f67x
resource "google_redis_instance" "push_prod" {
  auth_enabled       = true
  authorized_network = "projects/bn-infra-9a5e/global/networks/bn-infra-vpc"
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  name               = "push-prod"
  display_name       = "push-prod redis"
  memory_size_gb     = 2
  redis_version      = "REDIS_7_0"
  tier               = "STANDARD_HA"
}

resource "google_dns_record_set" "dn_redis_push_prod" {
  name         = "redis-push-prod.dn.bn.nr."
  type         = "A"
  ttl          = 300
  managed_zone = "bnnr"
  rrdatas      = [google_redis_instance.push_prod.host]
}

# terraform output -raw push_prod_auth_string
output "push_prod_auth_string" {
  value     = google_redis_instance.push_prod.auth_string
  sensitive = true
}


# https://console.cloud.google.com/memorystore/redis/locations/europe-west1/instances/auth-prod/details/overview?project=infra-dagens-nyheter-f67x
resource "google_redis_instance" "auth_prod" {
  auth_enabled       = true
  authorized_network = "projects/bn-infra-9a5e/global/networks/bn-infra-vpc"
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  name               = "auth-prod"
  display_name       = "auth-prod redis"
  memory_size_gb     = 4
  redis_version      = "REDIS_6_X"
  tier               = "STANDARD_HA"
}

resource "google_secret_manager_secret" "redis_auth_password_prod" {
  secret_id = "redis-auth-password-prod"
  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "redis_auth_password_prod" {
  secret      = google_secret_manager_secret.redis_auth_password_prod.id
  secret_data = google_redis_instance.auth_prod.auth_string
}

# https://console.cloud.google.com/memorystore/redis/locations/europe-west1/instances/skola-prod/details/overview?project=infra-dagens-nyheter-f67x
resource "google_redis_instance" "skola_prod" {
  auth_enabled       = true
  authorized_network = "projects/bn-infra-9a5e/global/networks/bn-infra-vpc"
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  name               = "skola-prod"
  display_name       = "skola-prod redis"
  memory_size_gb     = 1
  redis_version      = "REDIS_6_X"
  tier               = "STANDARD_HA"
}

resource "google_dns_record_set" "dn_redis_skola_prod" {
  name         = "redis-skola-prod.dn.bn.nr."
  type         = "A"
  ttl          = 300
  managed_zone = "bnnr"
  rrdatas      = [google_redis_instance.skola_prod.host]
}

# terraform output -raw skola_prod_auth_string
output "skola_prod_auth_string" {
  value     = google_redis_instance.skola_prod.auth_string
  sensitive = true
}
