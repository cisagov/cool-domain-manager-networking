# ------------------------------------------------------------------------------
# Create an ACM certificate for Domain Manager.
# ------------------------------------------------------------------------------

resource "aws_acm_certificate" "domainmanager" {
  provider = aws.domainmanager_provisionaccount

  domain_name       = local.domainmanager_domain
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = { "app" = "domain-manager" }
}

# ------------------------------------------------------------------------------
# Create public DNS record(s) containing validation information for the
# Domain Manager ACM certificate created above.
# ------------------------------------------------------------------------------

resource "aws_route53_record" "domainmanager_certificate_validation" {
  provider = aws.dns_cyber_dhs_gov

  for_each = {
    for dvo in aws_acm_certificate.domainmanager.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.terraform_remote_state.dns_cyber_dhs_gov.outputs.cyber_dhs_gov_zone.zone_id

  depends_on = [aws_acm_certificate.domainmanager]
}

# ------------------------------------------------------------------------------
# Validate the Domain Manager ACM certificate created above.
# ------------------------------------------------------------------------------

resource "aws_acm_certificate_validation" "domainmanager" {
  provider = aws.domainmanager_provisionaccount

  certificate_arn         = aws_acm_certificate.domainmanager.arn
  validation_record_fqdns = [for record in aws_route53_record.domainmanager_certificate_validation : record.fqdn]
}
