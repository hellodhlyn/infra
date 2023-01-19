module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0"

  project_id   = var.project_id
  network_name = "${var.cluster_name}-vpc"

  subnets = [
    {
      subnet_name   = local.subnet_name
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = local.range_pods_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name   = local.range_services_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}
