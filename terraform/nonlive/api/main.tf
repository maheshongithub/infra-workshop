locals {
  env          = "nonlive"
  domain_root  = "devops-learnings.net"
  service_name = "api"
  target_port  = 9966
}

module "database" {
  source = "../../modules/rds"

  name                 = "petclinic"
  vpc_name             = local.env
  default_db_name      = "petclinic"
  master_user_password = data.aws_secretsmanager_secret_version.rds_master_password.secret_string
}

module "api-deploy" {
  source = "../../modules/ec2-deploy"

  ami_id             = data.aws_ami.ami.id
  domain_root        = local.domain_root
  public_key_content = tls_private_key.api.public_key_openssh
  service_name       = local.service_name
  vpc_name           = local.env
  target_port        = local.target_port
  health_check_path  = "/petclinic/swagger-ui.html"

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    jdbc_url               = "jdbc:postgresql://${module.database.endpoint}/petclinic",
    postgres_user_password = data.aws_secretsmanager_secret_version.rds_master_password.secret_string
  }))
}

resource "tls_private_key" "api" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

