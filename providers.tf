# This is the "default" provider that is used assume the roles in the other
# providers.  It uses the credentials of the caller.  It is also used to
# assume the roles required to access remote state in the Terraform backend.

provider "aws" {
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to modify DNS records in the cyber.dhs.gov zone.
provider "aws" {
  alias = "dns_cyber_dhs_gov"
  assume_role {
    role_arn     = data.terraform_remote_state.dns_cyber_dhs_gov.outputs.route53resourcechange_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to create resources inside the Domain Manager account.
provider "aws" {
  alias = "domainmanager_provisionaccount"
  assume_role {
    role_arn     = data.terraform_remote_state.domainmanager.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to lookup account IDs.  See locals.
provider "aws" {
  alias = "organizationsreadonly"
  assume_role {
    role_arn     = data.terraform_remote_state.master.outputs.organizationsreadonly_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to manipulate the Transit Gateway in the Shared Services
# account and to associate the Domain Manager VPC with the Route53 (private
# DNS) zone in the Shared Services account.
provider "aws" {
  alias = "provisionsharedservices"
  assume_role {
    role_arn     = data.terraform_remote_state.sharedservices.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to create the role allowing read-only access to this
# project's Terraform state in the Terraform account.
provider "aws" {
  alias = "provisionterraform"
  assume_role {
    role_arn     = data.terraform_remote_state.terraform.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    # It makes no sense to associate a "Workspace" tag with the
    # Terraform read role, since it can read the state from any
    # workspace.
    #
    # Such a tag will also flip flop as one switched from staging to
    # production or vice versa, which is highly annoying.
    tags = { for k, v in var.tags : k => v if k != "Workspace" }
  }
  region = var.aws_region
}

# The provider used to create resources inside the Users account.
provider "aws" {
  alias = "provisionusers"
  assume_role {
    role_arn     = data.terraform_remote_state.users.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}
