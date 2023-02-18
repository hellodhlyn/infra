#
# https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/latest/submodules/postgresql
#
module "postgres" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 13.0"

  name             = "${var.cluster_name}-db"
  database_version = "POSTGRES_14"

  project_id        = var.project_id
  region            = var.region
  zone              = data.google_compute_zones.available.names[0]
  availability_type = "ZONAL"
  tier              = var.db_tier

  disk_autoresize = false

  db_name   = "postgres"
  user_name = "postgres"

  ip_configuration = {
    ipv4_enabled        = false
    private_network     = module.vpc.network.network_id 
    authorized_networks = []
    require_ssl         = null
    allocated_ip_range  = null
  }

  backup_configuration = {
    enabled = true

    location         = "asia"
    start_time       = "17:00"
    retained_backups = 3
    retention_unit   = "COUNT"

    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
  }

  maintenance_window_day          = 6
  maintenance_window_hour         = 19
  maintenance_window_update_track = "stable"
}
