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
