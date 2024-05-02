resource "google_sql_database_instance" "postgres_pvp_instance_name" {
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



##################################################################
##########################################################33333333333333
terraform {
  required_version = ">= 1.4.6"
  backend "gcs" {
    bucket = "dagens-nyheter-terraform-states"
    prefix = "pg-prod"
  }
}

provider "google" {
  project = "infra-dagens-nyheter-f67x"
  region  = "europe-west1"
}

# https://console.cloud.google.com/sql/instances/dn-db-prod/overview?project=infra-dagens-nyheter-f67x
resource "google_sql_database_instance" "dn-db" {
  database_version    = "POSTGRES_14"
  deletion_protection = true
  name                = "dn-db-prod"

  settings {
    tier              = "db-custom-2-7680"
    disk_type         = "PD_SSD"
    disk_size         = 20
    availability_type = "REGIONAL"
    deletion_protection_enabled = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/bn-infra-9a5e/global/networks/bn-infra-vpc"
      authorized_networks {
        name  = "devnetwork"
        value = "193.180.57.64/28"
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

resource "google_sql_user" "dn-prod" {
  name     = "dn-prod"
  instance = google_sql_database_instance.dn-db.name
  password = data.google_secret_manager_secret_version.pg-dn-prod.secret_data
}

data "google_secret_manager_secret_version" "pg-dn-prod" {
  secret = "pg-dn-prod"
}

resource "google_sql_database" "dn-user-prod" {
  name     = "dn-user-prod"
  instance = google_sql_database_instance.dn-db.name
}

resource "google_sql_database" "dn-internal-prod" {
  name     = "dn-internal-prod"
  instance = google_sql_database_instance.dn-db.name
}

resource "google_dns_record_set" "dns" {
  name         = "postgres-prod.dn.bn.nr."
  type         = "A"
  ttl          = 300
  managed_zone = "bnnr"
  rrdatas      = [google_sql_database_instance.dn-db.private_ip_address]
}
