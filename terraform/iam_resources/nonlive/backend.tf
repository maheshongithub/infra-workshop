terraform {
  required_version = "0.13.6"
  backend "s3" {
    bucket         = "mahesh-infra-workshop-backend-store"
    region         = "ap-south-1"
    key            = "iam.tfstate"
    dynamodb_table = "terraform-lock-table"
  }
}
