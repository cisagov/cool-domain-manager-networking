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
| aws | ~> 3.38 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.38 |
| aws.dns\_cyber\_dhs\_gov | ~> 3.38 |
| aws.domainmanager\_provisionaccount | ~> 3.38 |
| aws.organizationsreadonly | ~> 3.38 |
| aws.provisionsharedservices | ~> 3.38 |
| null | n/a |
| terraform | n/a |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| private | github.com/cisagov/distributed-subnets-tf-module | n/a |
| public | github.com/cisagov/distributed-subnets-tf-module | n/a |
| read\_terraform\_state | github.com/cisagov/terraform-state-read-role-tf-module | n/a |
| vpc\_flow\_logs | trussworks/vpc-flow-logs/aws | >=2.0.0, <2.1.0 |

## Resources ##

| Name | Type |
|------|------|
| [aws_acm_certificate.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_default_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_ec2_transit_gateway_route.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table_association.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.nat_gw_eips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_policy.provisionnetworking_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.provisionnetworking_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.cool_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.cool_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.external_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.external_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_record.domainmanager_certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_vpc_association_authorization.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_vpc_association_authorization) | resource |
| [aws_route53_zone_association.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |
| [aws_route_table.private_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_route_table_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_vpc.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [null_resource.break_association_with_default_route_table](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.domainmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.provisionnetworking_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.cool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [terraform_remote_state.dns_cyber_dhs_gov](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.domainmanager](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sharedservices](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sharedservices_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.terraform](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.users](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region to deploy into (e.g. us-east-1) | `string` | `"us-east-1"` | no |
| cool\_cidr\_block | The overall CIDR block associated with the COOL (e.g. "10.128.0.0/9"). | `string` | n/a | yes |
| domainmanager\_subdomain | The subdomain for Domain Manager (e.g. "domain-manager.cool"). | `string` | n/a | yes |
| private\_subnet\_cidr\_blocks | The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  This list must be the same length as public\_subnet\_cidr\_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| provisionnetworking\_policy\_description | The description to associate with the IAM policy that allows provisioning of the networking layer in the Domain Manager account. | `string` | `"Allows provisioning of the networking layer in the Domain Manager account."` | no |
| provisionnetworking\_policy\_name | The name to assign the IAM policy that allows provisioning of the networking layer in the Domain Manager account. | `string` | `"ProvisionNetworking"` | no |
| public\_subnet\_cidr\_blocks | The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  This list must be the same length as private\_subnet\_cidr\_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| read\_terraform\_state\_role\_name | The name to assign the IAM role and policy that allows read-only access to the cool-domain-manager-networking state in the S3 bucket where Terraform state is stored. | `string` | `"ReadDomainManagerNetworkingTerraformState"` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| vpc\_cidr\_block | The CIDR block to use for the Domain Manager VPC (e.g. "10.10.0.0/21"). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| domainmanager\_certificate | The ACM certificate for Domain Manager. |
| private\_subnet\_nat\_gws | The NAT gateways used in the private subnets in the Domain Manager VPC. |
| private\_subnets | The private subnets in the Domain Manager VPC. |
| public\_subnets | The public subnets in the Domain Manager VPC. |
| read\_terraform\_state | The IAM policies and role that allow read-only access to the Terraform state for Domain Manager networking. |
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
