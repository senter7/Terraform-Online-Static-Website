locals {
  zone_not_exist = var.hosted_zone_id == ""
}

resource "aws_route53_zone" "zone" {
  count = var.hosted_zone_id != "" ? 0 : 1
  name = var.root_domain_name
}

resource "aws_route53_record" "record" {
  zone_id = local.zone_not_exist ? aws_route53_zone.zone[0].id : var.hosted_zone_id
  name    = "www.${var.root_domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "root_domain_record" {
  name = ""
  type = "A"
  zone_id = local.zone_not_exist ? aws_route53_zone.zone[0].id : var.hosted_zone_id

  alias {
    name = aws_cloudfront_distribution.cdn_root_domain.domain_name
    zone_id = aws_cloudfront_distribution.cdn_root_domain.hosted_zone_id
    evaluate_target_health = false
  }
}