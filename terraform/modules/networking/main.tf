module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets

  private_subnet_tags = {
    SubnetType = "Private"
  }

  private_route_table_tags = {
    Tier = "private"
  }

  public_subnets = var.public_subnets

  public_subnet_tags = {
    SubnetType = "Public"
  }

  public_route_table_tags = {
    Tier = "public"
  }

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
