variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

variable "k3s_server_ip" {
  type      = string
  sensitive = true
}

variable "k3s_token" {
  type      = string
  sensitive = true
}

module "node-ls-tokyo-k3s-master01" {
  source = "./modules/k3s-master"

  node_name             = "ls-tokyo-k3s-master01"
  aws_availability_zone = "ap-northeast-1a"
  cloudflare_api_token  = var.cloudflare_api_token
  cloudflare_zone_id    = var.cloudflare_zone_id
}

module "node-ls-tokyo-k3s-agent01" {
  source = "./modules/k3s-agent"

  node_name             = "ls-tokyo-k3s-agent01"
  aws_availability_zone = "ap-northeast-1a"
  k3s_server_ip         = var.k3s_server_ip
  k3s_token             = var.k3s_token
}


// Cloudflare DNS records
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_dns_record" "cname-record-ls-tokyo-k3s-master01" {
  zone_id = var.cloudflare_zone_id
  content = "ls-tokyo-k3s-master01.master.lynlab.cc"
  name    = "ls-tokyo-k3s.cluster.lynlab.cc"
  proxied = true
  ttl     = 1
  type    = "CNAME"
}
