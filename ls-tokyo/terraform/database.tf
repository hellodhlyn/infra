variable "postgres_password" {
  type      = string
  sensitive = true
}

resource "aws_lightsail_database" "postgres_db" {
  relational_database_name = "ls-tokyo-postgres"
  availability_zone        = "ap-northeast-1a"
  master_database_name     = "postgres"
  master_username          = "root"
  master_password          = var.postgres_password
  blueprint_id             = "postgres_17"
  bundle_id                = "micro_2_0"

  # Backup configuration
  backup_retention_enabled = true
  preferred_backup_window = "17:00-18:00"  # KST 02:00-03:00

  # Maintenance configuration
  preferred_maintenance_window = "sun:19:00-sun:20:00"  # KST 04:00-05:00

  lifecycle {
    ignore_changes = [
      master_password,
      skip_final_snapshot,
    ]
  }
}
