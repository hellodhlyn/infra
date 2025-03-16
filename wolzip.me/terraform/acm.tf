variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "aws_acm_certificate" "social-wolzip-me" {
  provider          = aws.us-east-1
  domain_name       = "*.social.wolzip.me"
  validation_method = "DNS"

  tags = {
    Service = "wolzip"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_dns_record" "social-wolzip-me-validation" {
  for_each = {
    for dvo in aws_acm_certificate.social-wolzip-me.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.record
  proxied = false
  ttl     = 60
}
