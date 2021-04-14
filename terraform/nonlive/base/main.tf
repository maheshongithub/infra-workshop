module "networking" {
  source = "../../modules/networking"

  availability_zones = ["ap-south-1a", "ap-south-1b"]
  private_subnets    = ["10.64.64.0/18", "10.64.128.0/18"]
  public_subnets     = ["10.64.0.0/22", "10.64.4.0/22"]
  vpc_cidr           = "10.64.0.0/16"
  vpc_name           = "infra-workshop"
}
