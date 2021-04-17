variable "name" {}
variable "default_db_name" {}
variable "vpc_name" {}
variable "master_user_name" {
  default = "postgres"
}
variable "master_user_password" {}
variable "allocated_storage" {
  default = 20
}
variable "instance_class" {
  default = "db.t2.micro"
}
variable "postgres_engine_version" {
  default = "12.5"
}
variable "storage_type" {
  default = "gp2"
}
