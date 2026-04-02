variable "create_provider" {
  description = "Controls if the OIDC provider should be created. If false, you must ensure the provider exists and is identified by the `oidc_provider_url`."
  type        = bool
  default     = true
}

variable "oidc_provider_url" {
  description = "The URL of the OIDC identity provider (e.g., token.actions.githubusercontent.com for GitHub or gitlab.com for GitLab)."
  type        = string
}

variable "client_id_list" {
  description = "A list of client IDs (also known as audiences). When using GitHub Actions, the default is usually `sts.amazonaws.com`."
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

variable "thumbprint_list" {
  description = "A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s). AWS supports creating some providers with an empty list."
  type        = list(string)
  default     = []
}

variable "role_name" {
  description = "The name of the IAM role to create."
  type        = string
}

variable "role_description" {
  description = "The description of the IAM role."
  type        = string
  default     = "OIDC assumed role"
}

variable "role_policy_arns" {
  description = "A list of IAM policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "subjects" {
  description = "A list of subject claims (`sub`) allowed to assume the role. This uses StringLike conditions so wildcards (*) are supported. E.g., `repo:my-org/my-repo:*`."
  type        = list(string)
  default     = []
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours."
  type        = number
  default     = 3600
}

variable "force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
