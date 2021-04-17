data "aws_ami" "ami" {
  filter {
    name   = "name"
    values = ["petclinic-rest-*"]
  }
  most_recent = true
  owners      = ["self"]
}

data "aws_secretsmanager_secret" "rds_master_password" {
  name = "petclinic_rds_master_password"
}

data "aws_secretsmanager_secret_version" "rds_master_password" {
  secret_id = data.aws_secretsmanager_secret.rds_master_password.id
}
