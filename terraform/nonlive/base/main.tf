locals {
  env                  = "nonlive"
  root_domain          = "devops-learnings.net"
  vpc_cidr             = "10.64.0.0/16"
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  private_subnet_cidrs = ["10.64.64.0/18", "10.64.128.0/18"]
  public_subnet_cidrs  = ["10.64.0.0/22", "10.64.4.0/22"]
}

module "networking" {
  source = "../../modules/networking"

  availability_zones = local.availability_zones
  private_subnets    = local.private_subnet_cidrs
  public_subnets     = local.public_subnet_cidrs
  vpc_cidr           = local.vpc_cidr
  vpc_name           = local.env
}

module "dns_and_certs" {
  source = "../../modules/dns_and_certs"

  environment = local.env
  r53_zone    = local.root_domain
}
