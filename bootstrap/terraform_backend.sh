#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

AWS_REGION="ap-south-1"
TF_BUCKET_NAME="mahesh-infra-workshop-backend-store"
TF_BUCKET_REGION="${AWS_REGION}"
TF_TABLE_NAME="terraform-lock-table"

function create_terraform_state_bucket() {
  if ! aws --region "${AWS_REGION}" s3api head-bucket --bucket $TF_BUCKET_NAME; then
    aws --region "${AWS_REGION}" s3api create-bucket --bucket $TF_BUCKET_NAME \
      --create-bucket-configuration LocationConstraint="${AWS_REGION}"\

    aws --region "${AWS_REGION}" s3api wait bucket-exists --bucket $TF_BUCKET_NAME
  else
    echo "Bucket $TF_BUCKET_NAME already exists"
  fi

  aws --region "${AWS_REGION}" s3api put-bucket-versioning --bucket $TF_BUCKET_NAME \
    --versioning-configuration MFADelete=Disabled,Status=Enabled
  aws --region "${AWS_REGION}" s3api put-bucket-encryption --bucket $TF_BUCKET_NAME \
    --server-side-encryption-configuration '
{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
    }}
    ]
}'
}

function create_terraform_lock_table() {
  if ! aws --region "${AWS_REGION}" dynamodb describe-table --table-name $TF_TABLE_NAME; then
    aws --region "${AWS_REGION}" dynamodb create-table \
      --table-name $TF_TABLE_NAME \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --attribute-definitions AttributeName=LockID,AttributeType=S\
      --provisioned-throughput ReadCapacityUnits=20,WriteCapacityUnits=20

    aws --region "${AWS_REGION}" dynamodb wait table-exists --table-name terraform-lock-table
  else
    echo "Table $TF_TABLE_NAME already exists"
  fi
}

function main() {
    echo "Creating terraform backend for the AWS account"
    create_terraform_state_bucket
    create_terraform_lock_table
}

main
