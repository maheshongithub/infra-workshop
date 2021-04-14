resource "aws_route53_zone" "dns_zone" {
  count = var.create_zone ? 1 : 0
  name  = var.r53_zone

  tags = {
    environment = var.environment
  }
}

data "aws_route53_zone" "dns_zone" {
  count = var.create_zone ? 0 : 1
  name  = var.r53_zone
}
