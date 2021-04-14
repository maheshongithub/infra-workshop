resource "aws_acm_certificate" "certificate" {
  domain_name       = "*.${var.r53_zone}"
  validation_method = "DNS"
}

resource "aws_route53_record" "certificate_r53_record" {
  name    = aws_acm_certificate.certificate.domain_validation_options.*.resource_record_name[0]
  type    = aws_acm_certificate.certificate.domain_validation_options.*.resource_record_type[0]
  zone_id = aws_route53_zone.dns_zone.zone_id
  records = [
    aws_acm_certificate.certificate.domain_validation_options.*.resource_record_value[0]
  ]
  ttl = var.cert_ttl
}

resource "aws_acm_certificate_validation" "certificate_validate" {
  count           = var.validate_cert ? 1 : 0
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [
  aws_route53_record.certificate_r53_record.fqdn]
  timeouts {
    create = "5m"
  }
}
