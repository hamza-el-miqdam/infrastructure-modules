data "aws_caller_identity" "current" {}

locals {
  # We assume these roles are created in the management account and can be assumed by trusted entities
  # or they represent standard roles you might want to baseline.
  management_account_id = data.aws_caller_identity.current.account_id
}

# OrganizationAccountAccessRole (Often used for cross-account access from management account to member accounts)
resource "aws_iam_role" "org_account_access" {
  count = var.enable_iam_organization_account_access_role ? 1 : 0

  name = "OrganizationAccountAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.management_account_id}:root"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "org_account_access_admin" {
  count = var.enable_iam_organization_account_access_role ? 1 : 0

  role       = aws_iam_role.org_account_access[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# SecurityAudit Role
resource "aws_iam_role" "security_audit" {
  count = var.enable_iam_security_audit_role ? 1 : 0

  name = "SecurityAuditRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.management_account_id}:root"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "security_audit_attach" {
  count = var.enable_iam_security_audit_role ? 1 : 0

  role       = aws_iam_role.security_audit[0].name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# AdministratorAccess Role (A baseline admin role other than the OrgAccountAccessRole)
resource "aws_iam_role" "administrator_access" {
  count = var.enable_iam_administrator_access_role ? 1 : 0

  name = "BaselineAdministratorAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.management_account_id}:root"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "administrator_access_attach" {
  count = var.enable_iam_administrator_access_role ? 1 : 0

  role       = aws_iam_role.administrator_access[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
