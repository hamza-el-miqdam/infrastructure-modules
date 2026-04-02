output "organization_arn" {
  description = "ARN of the organization."
  value       = var.create_organization ? aws_organizations_organization.this[0].arn : data.aws_organizations_organization.existing[0].arn
}

output "organization_id" {
  description = "Identifier of the organization."
  value       = var.create_organization ? aws_organizations_organization.this[0].id : data.aws_organizations_organization.existing[0].id
}

output "organization_master_account_id" {
  description = "Account ID of the master account."
  value       = var.create_organization ? aws_organizations_organization.this[0].master_account_id : data.aws_organizations_organization.existing[0].master_account_id
}

output "organization_master_account_email" {
  description = "Email of the master account."
  value       = var.create_organization ? aws_organizations_organization.this[0].master_account_email : data.aws_organizations_organization.existing[0].master_account_email
}

output "organization_root_id" {
  description = "Identifier of the root."
  value       = local.root_id
}

output "organizational_units" {
  description = "Map of created Organizational Units (name to ID)."
  value       = { for ou in aws_organizations_organizational_unit.this : ou.name => ou.id }
}

output "iam_role_organization_account_access_arn" {
  description = "ARN of the OrganizationAccountAccessRole."
  value       = var.enable_iam_organization_account_access_role ? aws_iam_role.org_account_access[0].arn : null
}

output "iam_role_security_audit_arn" {
  description = "ARN of the SecurityAudit role."
  value       = var.enable_iam_security_audit_role ? aws_iam_role.security_audit[0].arn : null
}

output "iam_role_administrator_access_arn" {
  description = "ARN of the BaselineAdministratorAccessRole."
  value       = var.enable_iam_administrator_access_role ? aws_iam_role.administrator_access[0].arn : null
}

output "scp_deny_root_access_id" {
  description = "ID of the DenyRootAccountAccess SCP."
  value       = var.enable_scp_deny_root_access ? aws_organizations_policy.deny_root_access[0].id : null
}

output "scp_require_mfa_id" {
  description = "ID of the RequireMFA SCP."
  value       = var.enable_scp_require_mfa ? aws_organizations_policy.require_mfa[0].id : null
}

output "scp_restrict_regions_id" {
  description = "ID of the RestrictRegions SCP."
  value       = var.enable_scp_restrict_regions ? aws_organizations_policy.restrict_regions[0].id : null
}
