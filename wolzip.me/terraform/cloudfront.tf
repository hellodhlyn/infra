locals {
  s3_origin_id = "wolzip-assets"
}

resource "aws_cloudfront_origin_access_control" "cloudfront-s3" {
  name                              = "CloudFront S3 for Wolzip"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "assets" {
  depends_on = [ aws_acm_certificate.social-wolzip-me ]

  comment         = "social.wolzip.me Assets"
  enabled         = true
  is_ipv6_enabled = true
  aliases         = [ "assets.social.wolzip.me" ]

  origin {
    domain_name              = aws_s3_bucket.assets-bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront-s3.id
    origin_id                = local.s3_origin_id
  }

  default_cache_behavior {
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"  # Managed-CachingOptimized
    target_origin_id = local.s3_origin_id
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]

    viewer_protocol_policy = "https-only"
    compress               = true

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.social-wolzip-me.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  tags = {
    Service = "wolzip"
  }
}
