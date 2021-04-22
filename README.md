# infra-workshop
This repo contains infrastructure automation to setup the petclinic 3-tier application

![Alt text](./arch.jpg?raw=true "Architecture and Deployment Diagram")

## Bootstrap
- Add the AWS access keys which has admin permissions on the AWS account
- Run `./terraform_backend.sh` from *bootstrap* directory

## Building images
- *Prerequisites:* Make sure the petclinic [rest](https://github.com/maheshongithub/spring-petclinic-rest) and [angular](https://github.com/maheshongithub/spring-petclinic-angular) repos are up-to-date on master
- Make sure to have the aws cli configured to the right account
- Run `./run_packer.sh` from *packer* directory. This will create the custom AMIs for petclinic rest and angular

## IAM resources
It is suggested to not allow the CI to create the IAM resources, as that would be a loophole for an attacker. Hence the IAM resources creation is not part of CI. Follow the below steps to create the IAM resources

- Make sure the aws cli is configured with the keys which has IAM resources creation permissions in the respective AWS account
- Go to `terraform/iam_resources/nonlive` (assuming the resources to be created in `nonlive` only) directory
- Run `terraform init` and then `terraform apply`

## Secrets setup
- Creation of the secrets are not setup as part of CI/CD
- Create a secret `petclinic_rds_master_password` with a strong password string, in `ap-south-1` (which is being used to create the other resources in AWS)

## CI/CD
- `Github Actions` being used for CI and CD
### Base infra
- Module `terraform/modules/networking` is being used to setup basic networking like `vpc`, `subnets`, `nat gateways` etc.
- Module `terraform/modules/dns_and_certs` is being used to setup `Route53` and `ACM certificates` resources
- The above two modules are being called from `terraform/nonlive/base`
- The `terraform apply` is being done from Github Actions workflow

### Petclinic API (rest)
- Module `terraform/modules/rds` is being used for RDS setup, with `postgres` engine. This is being `private` to the `VPC`
- Module `terraform/modules/ec2-deploy` is being used for creation of the EC2 resources like `autoscaling groups`, `launch templates`, `load balancers` etc.
- The `ec2-deploy` module would be common for both API and frontend (angular)
- The above two modules are being called from `terraform/nonlive/api`
- The `terraform apply` is being done from Github Actions workflow
- The secrets are being read at the time of `apply`
- The latest custom AMI id being passed while creating the EC2 resources
- This can be accessed at [https://api.devops-learnings.net](https://api.devops-learnings.net) (can be kept `internal` to VPC only)

### Petclinic API (rest)
- The `ec2-module` is being called from `terraform/nonlive/api`
- The `terraform apply` is being done from Github Actions workflow
- The latest custom AMI id being passed while creating the EC2 resources
- This can be accessed at [https://frontend.devops-learnings.net/petclinic/](https://frontend.devops-learnings.net/petclinic/)


## Scope for improvements
- Keeping the `api` internal to VPC. As the calls are being made externally, we need code changes in angular, so that the calls are made internally to api endpoint
- A few workarounds like `sed` commands are used
- API instance profile has `rds:*` permissions (though on that specific resource only). A fine-grained permissions can be given
- Currently only a user access keys being used in CI/CD, but can be made to dynamically assume the role and run/apply the respective resources
- I would suggest to have a distributed model of deployments (CI/CD setup within the respective applications repositories) in contrast to the current centralised model
