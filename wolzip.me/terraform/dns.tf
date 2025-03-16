resource "cloudflare_dns_record" "assets-social-wolzip-me" {
  zone_id = var.cloudflare_zone_id
  name    = "assets.social.wolzip.me"
  type    = "CNAME"
  content = aws_cloudfront_distribution.assets.domain_name
  proxied = false
  ttl     = 60
}
