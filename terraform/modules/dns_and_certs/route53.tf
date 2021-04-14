resource "aws_route53_zone" "dns_zone" {
  name = var.r53_zone

  tags = {
    environment = var.environment
  }
}
