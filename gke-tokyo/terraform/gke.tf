#
# https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/beta-autopilot-public-cluster
#
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  version = "~> 24.1.0"

  project_id = var.project_id
  name       = var.cluster_name
  region     = var.region

  network           = module.vpc.network_name
  subnetwork        = local.subnet_name 
  ip_range_pods     = local.range_pods_name
  ip_range_services = local.range_services_name

  release_channel                 = "REGULAR"
  enable_vertical_pod_autoscaling = true
}
