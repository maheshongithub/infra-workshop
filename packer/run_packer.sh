#!/usr/bin/env bash
set -e -o pipefail

export AWS_DEFAULT_REGION="ap-south-1"
export AMI_REGIONS="ap-south-1"
export SOURCE_AMI_FILTER_NAME="ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210223"
export OWNERS="099720109477"
export SSH_USERNAME="ubuntu"
export AMI_CUSTOM_NAME="petclinic-rest"
export INSTANCE_TYPE="t3.xlarge"
export AMI_REGIONS="ap-south-1"
export ROOT_BLOCK_DEVICE_SIZE_GB="20"

function main() {
  echo "Building AMI for petclinic-rest"
  packer validate petclinic-rest.json
  packer build petclinic-rest.json
#  echo "Building AMI for petclinic-angular"
#  packer validate petclinic-angular.json
#  packer build petclinic-angular.json
}

main
