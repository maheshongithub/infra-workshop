resource "aws_route53_record" "dns_record" {
  name    = var.service_name
  type    = "A"
  zone_id = data.aws_route53_zone.dns_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
  }
}
