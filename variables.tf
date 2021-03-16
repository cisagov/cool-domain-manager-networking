# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cool_cidr_block" {
  type        = string
  description = "The overall CIDR block associated with the COOL (e.g. \"10.128.0.0/9\")."
}

variable "domainmanager_subdomain" {
  type        = string
  description = "The subdomain for Domain Manager (e.g. \"domain-manager.cool\")."
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  This list must be the same length as public_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone."
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  This list must be the same length as private_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block to use for the Domain Manager VPC (e.g. \"10.10.0.0/21\")."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy into (e.g. us-east-1)"
  default     = "us-east-1"
}

variable "provisionnetworking_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows provisioning of the networking layer in the Domain Manager account."
  default     = "Allows provisioning of the networking layer in the Domain Manager account."
}

variable "provisionnetworking_policy_name" {
  type        = string
  description = "The name to assign the IAM policy that allows provisioning of the networking layer in the Domain Manager account."
  default     = "ProvisionNetworking"
}

variable "read_terraform_state_role_name" {
  type        = string
  description = "The name to assign the IAM role and policy that allows read-only access to the cool-domain-manager-networking state in the S3 bucket where Terraform state is stored."
  default     = "ReadDomainManagerNetworkingTerraformState"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created"
  default     = {}
}
