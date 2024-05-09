



resource "google_sql_database_instance" "saleor-db" {
  database_version    = "POSTGRES_14"
  deletion_protection = false 
  name                = "saleor-db-prod"

  settings {
    tier              = "db-custom-2-7680"
    disk_type         = "PD_SSD"
    disk_size         = 20
    availability_type = "REGIONAL"
    deletion_protection_enabled = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.private_network
      authorized_networks {
        name  = "devnetwork"
        value = "213.89.236.167/32"
      }
    }

#     backup_configuration {
#       enabled                        = true
#       location                       = "europe-north1"
#       start_time                     = "23:00"
#       point_in_time_recovery_enabled = true
#       transaction_log_retention_days = 7
#       backup_retention_settings {
#         retained_backups = 8
#       }
      
#     }

#     maintenance_window {
#       day  = 2
#       hour = 11
#     }
 } 
  
  }
# data "google_secret_manager_secret_version" "pg-saleor-prod" {
#   secret = "pg-saleor-prod"
# }

# resource "google_sql_user" "saleor-prod" {
#   name     = "saleor-prod"
#   instance = google_sql_database_instance.saleor-db.name
#   password = data.google_secret_manager_secret_version.pg-saleor-prod.secret_data
# }



# resource "google_sql_database" "saleor-user-prod" {
#   name     = "saleor-user-prod"
#   instance = google_sql_database_instance.saleor-db.name
# }


# resource "google_dns_record_set" "dns" {
#   name         = "postgres-prod.allistore.uk."
#   type         = "A"
#   ttl          = 300
#   managed_zone = "bnnr"######
#   rrdatas      = [google_sql_database_instance.saleor-db.private_ip_address]
# }
