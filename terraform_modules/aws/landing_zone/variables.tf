variable "create_organization" {
  description = "Controls whether to create a new AWS Organization or use an existing one."
  type        = bool
  default     = false
}

variable "aws_service_access_principals" {
  description = "List of AWS service principal names for which you want to enable integration with your organization."
  type        = list(string)
  default     = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com"
  ]
}

variable "enabled_policy_types" {
  description = "List of Organizations policy types to enable. Can be SERVICE_CONTROL_POLICY, TAG_POLICY, BACKUP_POLICY, and/or AISERVICES_OPT_OUT_POLICY."
  type        = list(string)
  default     = ["SERVICE_CONTROL_POLICY"]
}

variable "feature_set" {
  description = "Specify 'ALL' (default) or 'CONSOLIDATED_BILLING'."
  type        = string
  default     = "ALL"
}

variable "ou_creation_mode" {
  description = "Defines how to create OUs: 'BASIC' (only basic), 'BASIC_AND_CUSTOM' (basic + custom), 'CUSTOM' (only custom), or 'NONE'."
  type        = string
  default     = "BASIC_AND_CUSTOM"
  validation {
    condition     = contains(["BASIC", "BASIC_AND_CUSTOM", "CUSTOM", "NONE"], var.ou_creation_mode)
    error_message = "Valid values for ou_creation_mode are: BASIC, BASIC_AND_CUSTOM, CUSTOM, NONE."
  }
}

variable "custom_ous" {
  description = "List of custom Organizational Units to create. Used when ou_creation_mode is 'BASIC_AND_CUSTOM' or 'CUSTOM'."
  type        = list(string)
  default     = []
}

variable "enable_scp_deny_root_access" {
  description = "Enable the baseline SCP to deny root account access."
  type        = bool
  default     = true
}

variable "enable_scp_require_mfa" {
  description = "Enable the baseline SCP to require MFA for specific actions."
  type        = bool
  default     = true
}

variable "enable_scp_restrict_regions" {
  description = "Enable the baseline SCP to restrict allowed AWS regions."
  type        = bool
  default     = true
}

variable "allowed_regions" {
  description = "List of allowed regions for the restrict_regions SCP."
  type        = list(string)
  default     = ["us-east-1", "us-east-2", "us-west-2"]
}

variable "enable_iam_organization_account_access_role" {
  description = "Enable creation of OrganizationAccountAccessRole."
  type        = bool
  default     = false
}

variable "enable_iam_security_audit_role" {
  description = "Enable creation of SecurityAudit role."
  type        = bool
  default     = false
}

variable "enable_iam_administrator_access_role" {
  description = "Enable creation of AdministratorAccess role."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
