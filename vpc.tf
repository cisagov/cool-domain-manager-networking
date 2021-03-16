#-------------------------------------------------------------------------------
# Create the Domain Manager VPC.
#-------------------------------------------------------------------------------

resource "aws_vpc" "domainmanager" {
  provider = aws.domainmanager_provisionaccount

  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = var.tags
}

# The internet gateway for the VPC
resource "aws_internet_gateway" "domainmanager" {
  provider = aws.domainmanager_provisionaccount

  vpc_id = aws_vpc.domainmanager.id
  tags   = var.tags
}
