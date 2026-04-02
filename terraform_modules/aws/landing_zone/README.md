# AWS Landing Zone Terraform Module

This module provisions a highly customizable and foundational AWS Landing Zone. It strictly adheres to AWS Well-Architected Framework and Landing Zone best practices by providing a multi-account organization structure, essential security guardrails (SCPs), and baseline IAM roles.

## Architectural Choices

1. **Flexibility First**: Rather than forcing a rigid structure, the module is designed with extensive feature flags. You can easily adapt it to greenfield organizations (where it creates the AWS Organization) or brownfield ones (where it imports/reads existing structures).
2. **Modular Baseline**:
   - **OUs**: It offers a standard baseline of OUs (Security, Infrastructure, Workloads, Sandbox) but allows disabling these or augmenting them with custom OUs via the `ou_creation_mode` variable.
   - **SCPs**: Standard security guardrails (Deny Root Access, Require MFA, Restrict Regions) are provided out-of-the-box as Service Control Policies attached to the organization root. They are individually toggleable.
   - **IAM Roles**: Core baseline roles (`OrganizationAccountAccessRole`, `SecurityAudit`, `AdministratorAccess`) are provided as optional components to bootstrap cross-account access and auditability within the management account.
3. **No Account Vending**: To keep responsibilities separated, this module focuses strictly on the organizational structural baseline (OUs, Policies, Core Roles). Account vending and specific baseline provisioning per account are left to higher-level tools (like AWS Control Tower) or separate modules.

## Usage Example

```hcl
module "landing_zone" {
  source = "./terraform_modules/aws/landing_zone"

  # Orgnization Configuration
  create_organization           = true
  aws_service_access_principals = ["cloudtrail.amazonaws.com", "sso.amazonaws.com"]

  # Organizational Units Configuration
  ou_creation_mode = "BASIC_AND_CUSTOM"
  custom_ous       = ["Exceptions", "Suspended"]

  # Service Control Policies (SCPs)
  enable_scp_deny_root_access = true
  enable_scp_require_mfa      = true
  enable_scp_restrict_regions = true
  allowed_regions             = ["us-east-1", "us-east-2", "eu-west-1"]

  # Core IAM Baseline Roles
  enable_iam_organization_account_access_role = true
  enable_iam_security_audit_role              = true
  enable_iam_administrator_access_role        = false

  tags = {
    Environment = "Management"
    ManagedBy   = "Terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8 |
| aws | >= 5.0.0, < 7.0.0 |

## Inputs

Please review the `variables.tf` file for a comprehensive list of inputs, descriptions, and defaults.

## Outputs

Please review the `outputs.tf` file for a comprehensive list of exported values, such as organization IDs, OU IDs, and policy IDs.
