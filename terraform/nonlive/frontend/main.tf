locals {
  env          = "nonlive"
  domain_root  = "devops-learnings.net"
  service_name = "frontend"
}

module "frontend-deploy" {
  source = "../../modules/ec2-deploy"

  ami_id             = data.aws_ami.ami.id
  domain_root        = local.domain_root
  public_key_content = tls_private_key.frontend.public_key_openssh
  service_name       = local.service_name
  vpc_name           = local.env
  health_check_path  = "/petclinic/"
  user_data = ""
}

resource "tls_private_key" "frontend" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
