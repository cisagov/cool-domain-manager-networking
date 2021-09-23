output "domainmanager_certificate" {
  value       = aws_acm_certificate.domainmanager
  description = "The ACM certificate for Domain Manager."
  sensitive   = true
}

output "private_subnet_nat_gws" {
  value       = aws_nat_gateway.nat_gws
  description = "The NAT gateways used in the private subnets in the Domain Manager VPC."
}

output "private_subnets" {
  value       = module.private.subnets
  description = "The private subnets in the Domain Manager VPC."
}

output "public_subnets" {
  value       = module.public.subnets
  description = "The public subnets in the Domain Manager VPC."
}

output "read_terraform_state" {
  value       = module.read_terraform_state
  description = "The IAM policies and role that allow read-only access to the Terraform state for Domain Manager networking."
}

output "vpc" {
  value       = aws_vpc.domainmanager
  description = "The Domain Manager VPC."
}
