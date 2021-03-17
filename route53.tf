# Associate Domain Manager VPC with Shared Services Route53 (private DNS) zone
resource "aws_route53_vpc_association_authorization" "domainmanager" {
  provider = aws.provisionsharedservices

  vpc_id  = aws_vpc.domainmanager.id
  zone_id = data.terraform_remote_state.sharedservices_networking.outputs.private_zone.id
}

resource "aws_route53_zone_association" "domainmanager" {
  provider = aws.domainmanager_provisionaccount

  vpc_id  = aws_route53_vpc_association_authorization.domainmanager.vpc_id
  zone_id = aws_route53_vpc_association_authorization.domainmanager.zone_id
}
