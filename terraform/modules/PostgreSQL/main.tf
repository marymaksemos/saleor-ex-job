/* resource "google_sql_database_instance" "postgres_pvp_instance_name" {
  name             = "postgres-pvp-instance-name"
  region           = "asia-northeast1"
  database_version = "POSTGRES_14"
  root_password    = "abcABC123!"
  settings {
    tier = "db-custom-2-7680"
    password_validation_policy {
      min_length                  = 6
      reuse_interval              = 2
      complexity                  = "COMPLEXITY_DEFAULT"
      disallow_username_substring = true
      password_change_interval    = "30s"
      enable_password_policy      = true
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}
resource "random_password" "pwd" {
  length  = 16
  special = false
}

resource "google_sql_user" "user" {
  name     = "user"
  instance = google_sql_database_instance.instance.name
  password = random_password.pwd.result
}

 */

##################################################################
##########################################################33333333333333



resource "google_sql_database_instance" "saleor-db" {
  database_version    = "POSTGRES_14"
  deletion_protection = true
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

    backup_configuration {
      enabled                        = true
      location                       = "europe-north1"
      start_time                     = "23:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 8
      }
    }

    maintenance_window {
      day  = 2
      hour = 11
    }
  }
}
data "google_secret_manager_secret_version" "pg-saleor-prod" {
  secret = "pg-saleor-prod"
}

resource "google_sql_user" "saleor-prod" {
  name     = "saleor-prod"
  instance = google_sql_database_instance.saleor-db.name
  password = data.google_secret_manager_secret_version.pg-saleor-prod.secret_data
}



resource "google_sql_database" "saleor-user-prod" {
  name     = "saleor-user-prod"
  instance = google_sql_database_instance.saleor-db.name
}


# resource "google_dns_record_set" "dns" {
#   name         = "postgres-prod.allistore.uk."
#   type         = "A"
#   ttl          = 300
#   managed_zone = "bnnr"######
#   rrdatas      = [google_sql_database_instance.saleor-db.private_ip_address]
# }
