#-------------------------------------------------------------------------------
# Turn on flow logs for the VPC.
#-------------------------------------------------------------------------------
module "vpc_flow_logs" {
  source = "trussworks/vpc-flow-logs/aws"
  # Version 2.1.0 dropped support for TF 0.12
  version = ">=2.0.0, <2.1.0"
  providers = {
    aws = aws.domainmanager_provisionaccount
  }

  vpc_name       = "domainmanager"
  vpc_id         = aws_vpc.domainmanager.id
  logs_retention = "365"
}
