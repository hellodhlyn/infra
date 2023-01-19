terraform {
  required_version = "~> 1.3"
}

locals {
  subnet_name = "${var.cluster_name}-subnet"

  range_pods_name     = "ip-ranges-pods-public"
  range_services_name = "ip-ranges-services-public"
}

data "google_client_config" "default" {}
