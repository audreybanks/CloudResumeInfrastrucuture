locals {
  domain = "audreybanks.com"
  fqn = "www.audreybanks.com"
}

data "aws_acm_certificate" "issued" {
  domain   = "www.audreybanks.com"
  statuses = ["ISSUED"]
  provider = aws.east1
}

data "aws_route53_zone" "current" {
  name = local.domain
}

resource "aws_cloudfront_origin_access_control" "oac_main_distribution" {
  name                              = "frontend-s3-oac"
  description                       = "OAC for the frontend S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "main_distribution" {
  enabled             = true
  aliases             = [local.fqn, local.domain]
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac_main_distribution.id
    origin_id                = aws_s3_bucket.frontend.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id       = aws_s3_bucket.frontend.id
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.issued.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_route53_record" "cloudfront_route53_record" {
  name    = local.domain
  zone_id = data.aws_route53_zone.current.id
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.main_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.main_distribution.hosted_zone_id
  }
}

resource "aws_route53_record" "cloudfront_route53_record_ipv6" {
  name    = local.domain
  zone_id = data.aws_route53_zone.current.id
  type    = "AAAA"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.main_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.main_distribution.hosted_zone_id
  }
}

resource "aws_route53_record" "cloudfront_route53_record_b" {
  name    = local.fqn
  zone_id = data.aws_route53_zone.current.id
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.main_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.main_distribution.hosted_zone_id
  }
}

resource "aws_route53_record" "cloudfront_route53_record_b_ipv6" {
  name    = local.fqn
  zone_id = data.aws_route53_zone.current.id
  type    = "AAAA"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.main_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.main_distribution.hosted_zone_id
  }
}