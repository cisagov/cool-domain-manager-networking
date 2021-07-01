# ------------------------------------------------------------------------------
# Attach VPC to the Transit Gateway in the Shared Services account
# (see https://github.com/cisagov/cool-sharedservices-networking).
#
# Note that this attachment will be automatically accepted as long
# as the Transit Gateway was set up with:
#  auto_accept_shared_attachments = "enable"
#
# Note also that we are associating to the TGW VPC attachment a
# particular route table.  This route table allows communication to
# the Shared Services account, but nowhere else.  This serves to
# isolate the assessment accounts from each other.
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_vpc_attachment" "domainmanager" {
  provider = aws.domainmanager_provisionaccount

  subnet_ids         = [for s in module.private.subnets : s.id]
  transit_gateway_id = local.transit_gateway_id
  vpc_id             = aws_vpc.domainmanager.id
}

# Break the association between the Transit Gateway VPC attachment and
# the default Transit Gateway route table.
#
# It would be nice not to have to use the Terraform escape hatch for
# this, but Terraform just doesn't support this sort of cross-account
# foo right now.
resource "null_resource" "break_association_with_default_route_table" {
  # Require that the transit gateway VPC attachment is created before
  # breaking the association.
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.domainmanager,
  ]

  provisioner "local-exec" {
    when = create
    # This command asks AWS to disassociate the default route table
    # from our transit gateway attachment, then loops until the
    # disassociation is complete.
    command = "aws --profile cool-sharedservices-provisionaccount --region ${var.aws_region} ec2 disassociate-transit-gateway-route-table --transit-gateway-route-table-id ${local.transit_gateway_default_route_table_id} --transit-gateway-attachment-id ${aws_ec2_transit_gateway_vpc_attachment.domainmanager.id} && while aws --profile cool-sharedservices-provisionaccount --region ${var.aws_region} ec2 get-transit-gateway-route-table-associations --transit-gateway-route-table-id ${local.transit_gateway_default_route_table_id} | grep --quiet ${aws_vpc.domainmanager.id}; do sleep 5s; done"
  }

  triggers = {
    tgw_default_route_table_id = local.transit_gateway_default_route_table_id
    tgw_vpc_attachment_id      = aws_ec2_transit_gateway_vpc_attachment.domainmanager.id
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "domainmanager" {
  depends_on = [
    null_resource.break_association_with_default_route_table,
  ]
  provider = aws.provisionsharedservices

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.domainmanager.id
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
}

# Add a route to the Domain Manager VPC.
resource "aws_ec2_transit_gateway_route" "domainmanager" {
  provider = aws.provisionsharedservices

  destination_cidr_block         = aws_vpc.domainmanager.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.domainmanager.id
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
}
