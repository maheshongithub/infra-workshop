data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    SubnetType = "Private"
  }
}

data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    SubnetType = "Public"
  }
}

data "aws_route53_zone" "dns_zone" {
  name = var.domain_root
}

data "aws_acm_certificate" "certificate" {
  domain = "*.${var.domain_root}"
}

