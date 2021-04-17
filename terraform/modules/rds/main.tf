locals {
  db_port = 5432
}

module "rds_postgres" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.34.0"

  identifier                = var.name
  instance_class            = var.instance_class
  engine                    = "postgres"
  engine_version            = var.postgres_engine_version
  publicly_accessible       = false
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  subnet_ids                = data.aws_subnet_ids.private_subnet_ids.ids
  name                      = var.default_db_name
  username                  = var.master_user_name
  password                  = var.master_user_password
  port                      = local.db_port
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  maintenance_window        = "Sun:00:00-Sun:03:00"
  backup_window             = "03:00-06:00"
  create_db_parameter_group = false
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.name}_rds_sg"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = local.db_port
    protocol    = "TCP"
    to_port     = local.db_port
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}_rds_sg"
  }
}

output "endpoint" {
  value = module.rds_postgres.this_db_instance_endpoint
}
