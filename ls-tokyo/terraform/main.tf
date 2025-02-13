variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

module "node-ls-tokyo-k3s01" {
  source = "./modules/node"

  node_name            = "ls-tokyo-k3s01"
  cloudflare_api_token = var.cloudflare_api_token
  cloudflare_zone_id   = var.cloudflare_zone_id
}
