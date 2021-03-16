# cool-domain-manager-networking #

[![GitHub Build Status](https://github.com/cisagov/cool-domain-manager-networking/workflows/build/badge.svg)](https://github.com/cisagov/cool-domain-manager-networking/actions)

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system.
- An accessible AWS S3 bucket to store Terraform state
  (specified in [`backend.tf`](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified in [`backend.tf`](backend.tf)).
- Access to all of the Terraform remote states specified in
  [`remote_states.tf`](remote_states.tf).
- The following COOL accounts and roles must have been created:
  - Domain Manager:
    [`cisagov/cool-accounts-domain-manager`](https://github.com/cisagov/cool-accounts-domain-manager)
  - Master:
    [`cisagov/cool-accounts/master`](https://github.com/cisagov/cool-accounts/master)
  - Shared Services:
    [`cisagov/cool-accounts/sharedservices`](https://github.com/cisagov/cool-accounts/sharedservices)
  - Terraform:
    [`cisagov/cool-accounts/terraform`](https://github.com/cisagov/cool-accounts/terraform)
  - Users:
    [`cisagov/cool-accounts/users`](https://github.com/cisagov/cool-accounts/users)
- Terraform in
  [`cisagov/cool-dns-cyber.dhs.gov`](https://github.com/cisagov/cool-dns-cyber.dhs.gov)
  must have been applied.
- Terraform in
  [`cisagov/cool-sharedservices-networking`](https://github.com/cisagov/cool-sharedservices-networking)
  must have been applied.
- A Terraform [variables](variables.tf) file customized for your
  environment, for example:

  ```hcl
  cool_cidr_block = "10.128.0.0/9"
  private_subnet_cidr_blocks = [
    "10.10.2.0/24",
    "10.10.3.0/24",
  ]
  public_subnet_cidr_blocks = [
    "10.10.0.0/24",
    "10.10.1.0/24",
  ]
  vpc_cidr_block = "10.10.0.0/21"
  ```

## Building the Terraform-based infrastructure ##

1. Create a Terraform workspace (if you haven't already done so) for
   your assessment by running `terraform workspace new <workspace_name>`.

   **IMPORTANT:** The Terraform workspace name must be the same as an
   existing Terraform workspace for your deployment of
   [`cisagov/cool-accounts-domain-manager`](https://github.com/cisagov/cool-accounts-domain-manager)
   (e.g. `staging`, `production`, etc.) or your deployment will fail.
1. Create a `<workspace_name>.tfvars` file with all of the required
   variables (see [Inputs](#Inputs) below for details).
1. Run the command `terraform init`.
1. Add all necessary permissions by running the command:

   ```console
   terraform apply -var-file=<workspace_name>.tfvars --target=aws_iam_policy.provisionnetworking_policy --target=aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
   ```

1. Create all remaining Terraform infrastructure by running the command:

   ```console
   terraform apply -var-file=<workspace_name>.tfvars
   ```

## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 3.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| aws.dns_cyber_dhs_gov | ~> 3.0 |
| aws.domainmanager_provisionaccount | ~> 3.0 |
| aws.organizationsreadonly | ~> 3.0 |
| aws.provisionsharedservices | ~> 3.0 |
| null | n/a |
| terraform | n/a |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | The AWS region to deploy into (e.g. us-east-1) | `string` | `us-east-1` | no |
| cool_cidr_block | The overall CIDR block associated with the COOL (e.g. "10.128.0.0/9"). | `string` | n/a | yes |
| domainmanager_subdomain | The subdomain for Domain Manager (e.g. "domain-manager.cool"). | `string` | n/a | yes |
| private_subnet_cidr_blocks | The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  This list must be the same length as public_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| provisionnetworking_policy_description | The description to associate with the IAM policy that allows provisioning of the networking layer in the Domain Manager account. | `string` | `Allows provisioning of the networking layer in the Domain Manager account.` | no |
| provisionnetworking_policy_name | The name to assign the IAM policy that allows provisioning of the networking layer in the Domain Manager account. | `string` | `ProvisionNetworking` | no |
| public_subnet_cidr_blocks | The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  This list must be the same length as private_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| read_terraform_state_role_name | The name to assign the IAM role and policy that allows read-only access to the cool-domain-manager-networking state in the S3 bucket where Terraform state is stored. | `string` | `ReadDomainManagerNetworkingTerraformState` | no |
| tags | Tags to apply to all AWS resources created | `map(string)` | `{}` | no |
| vpc_cidr_block | The CIDR block to use for the Domain Manager VPC (e.g. "10.10.0.0/21"). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| domainmanager_certificate | The ACM certificate for Domain Manager. |
| private_subnet_nat_gws | The NAT gateways used in the private subnets in the Domain Manager VPC. |
| private_subnets | The private subnets in the Domain Manager VPC. |
| public_subnets | The public subnets in the Domain Manager VPC. |
| read_terraform_state | The IAM policies and role that allow read-only access to the Terraform state for Domain Manager networking. |
| vpc | The Domain Manager VPC. |

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, this is just the main directory.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
