# Deny Root User Access
data "aws_iam_policy_document" "deny_root_access" {
  count = var.enable_scp_deny_root_access ? 1 : 0

  statement {
    sid       = "DenyRootAccountAccess"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:root"]
    }
  }
}

resource "aws_organizations_policy" "deny_root_access" {
  count = var.enable_scp_deny_root_access ? 1 : 0

  name        = "DenyRootAccountAccess"
  description = "Deny all actions by the root user."
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.deny_root_access[0].json
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "deny_root_access_root" {
  count = var.enable_scp_deny_root_access ? 1 : 0

  policy_id = aws_organizations_policy.deny_root_access[0].id
  target_id = local.root_id
}

# Require MFA
data "aws_iam_policy_document" "require_mfa" {
  count = var.enable_scp_require_mfa ? 1 : 0

  statement {
    sid       = "RequireMFA"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
    # Usually you exclude certain operations that can't use MFA or are used to set it up
    # This is a generic broad stroke for demonstration
  }
}

resource "aws_organizations_policy" "require_mfa" {
  count = var.enable_scp_require_mfa ? 1 : 0

  name        = "RequireMFA"
  description = "Require MFA for AWS actions."
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.require_mfa[0].json
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "require_mfa_root" {
  count = var.enable_scp_require_mfa ? 1 : 0

  policy_id = aws_organizations_policy.require_mfa[0].id
  target_id = local.root_id
}

# Restrict Regions
data "aws_iam_policy_document" "restrict_regions" {
  count = var.enable_scp_restrict_regions ? 1 : 0

  statement {
    sid       = "RestrictRegions"
    effect    = "Deny"
    not_actions = [
      "a4b:*",
      "acm:*",
      "aws-marketplace-management:*",
      "aws-marketplace:*",
      "aws-portal:*",
      "budgets:*",
      "ce:*",
      "chime:*",
      "cloudfront:*",
      "config:*",
      "cur:*",
      "directconnect:*",
      "ec2:DescribeRegions",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpnGateways",
      "fms:*",
      "globalaccelerator:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "kms:*",
      "mobileanalytics:*",
      "networkmanager:*",
      "organizations:*",
      "pricing:*",
      "route53:*",
      "route53domains:*",
      "s3:GetAccountPublic*",
      "s3:ListAllMyBuckets",
      "s3:PutAccountPublic*",
      "shield:*",
      "sts:*",
      "support:*",
      "trustedadvisor:*",
      "waf-regional:*",
      "waf:*",
      "wafv2:*"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = var.allowed_regions
    }
  }
}

resource "aws_organizations_policy" "restrict_regions" {
  count = var.enable_scp_restrict_regions ? 1 : 0

  name        = "RestrictRegions"
  description = "Restrict AWS resources to allowed regions."
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.restrict_regions[0].json
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "restrict_regions_root" {
  count = var.enable_scp_restrict_regions ? 1 : 0

  policy_id = aws_organizations_policy.restrict_regions[0].id
  target_id = local.root_id
}
