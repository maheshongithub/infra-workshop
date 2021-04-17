variable "service_name" {}
variable "vpc_name" {}
variable "domain_root" {}
variable "ami_id" {}
variable "user_data" {}
variable "public_key_content" {}
variable "health_check_path" {
  default = "/"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ebs_volume_size" {
  default = 20
}
variable "is_private" {
  default = false
}
variable "asg_max" {
  default = 3
}
variable "asg_min" {
  default = 1
}
variable "asg_desired" {
  default = 2
}
variable "target_port" {
  default = 80
}
variable "strict_https" {
  default = false
}
