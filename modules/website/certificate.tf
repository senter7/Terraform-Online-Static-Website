resource "aws_acm_certificate" "cert" {
  provider = aws.virginia
  domain_name = var.root_domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validations" {
  count = length(var.subject_alternative_names)

  zone_id = local.zone_not_exist ? aws_route53_zone.zone[0].id : var.hosted_zone_id
  name    = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_name, count.index)
  type    = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_type, count.index)
  records = [element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_value, count.index)]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.virginia
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.cert_validations.*.fqdn
}
