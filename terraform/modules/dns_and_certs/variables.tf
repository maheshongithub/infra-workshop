variable "environment" {}
variable "validate_cert" {
  type    = bool
  default = true
}
variable "cert_ttl" {
  default = "60"
}
variable "r53_zone" {}
variable "create_zone" {
  default = false
}
