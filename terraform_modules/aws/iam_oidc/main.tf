locals {
  # Strip https:// prefix for the policy condition keys if present
  clean_provider_url = replace(var.oidc_provider_url, "https://", "")

  # The provider ARN is either created by this module or retrieved from data source
  provider_arn = var.create_provider ? aws_iam_openid_connect_provider.this[0].arn : data.aws_iam_openid_connect_provider.existing[0].arn
}

resource "aws_iam_openid_connect_provider" "this" {
  count = var.create_provider ? 1 : 0

  url             = startswith(var.oidc_provider_url, "https://") ? var.oidc_provider_url : "https://${var.oidc_provider_url}"
  client_id_list  = var.client_id_list
  thumbprint_list = var.thumbprint_list

  tags = var.tags
}

data "aws_iam_openid_connect_provider" "existing" {
  count = var.create_provider ? 0 : 1

  url = startswith(var.oidc_provider_url, "https://") ? var.oidc_provider_url : "https://${var.oidc_provider_url}"
}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.clean_provider_url}:aud"
      values   = var.client_id_list
    }

    dynamic "condition" {
      for_each = length(var.subjects) > 0 ? [1] : []
      content {
        test     = "StringLike"
        variable = "${local.clean_provider_url}:sub"
        values   = var.subjects
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role_with_oidc.json
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.role_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = var.role_policy_arns[count.index]
}
