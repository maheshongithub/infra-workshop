data "aws_ami" "ami" {
  filter {
    name   = "name"
    values = ["petclinic-angular-*"]
  }
  most_recent = true
  owners      = ["self"]
}
