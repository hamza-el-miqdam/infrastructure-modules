data "aws_organizations_organization" "existing" {
  count = var.create_organization ? 0 : 1
}

resource "aws_organizations_organization" "this" {
  count = var.create_organization ? 1 : 0

  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set
}

locals {
  root_id = var.create_organization ? aws_organizations_organization.this[0].roots[0].id : data.aws_organizations_organization.existing[0].roots[0].id

  basic_ous = ["Security", "Infrastructure", "Workloads", "Sandbox"]

  # Determine which OUs to create based on mode
  ous_to_create = (
    var.ou_creation_mode == "BASIC" ? local.basic_ous :
    var.ou_creation_mode == "BASIC_AND_CUSTOM" ? distinct(concat(local.basic_ous, var.custom_ous)) :
    var.ou_creation_mode == "CUSTOM" ? var.custom_ous :
    []
  )
}

resource "aws_organizations_organizational_unit" "this" {
  for_each  = toset(local.ous_to_create)

  name      = each.value
  parent_id = local.root_id

  tags = var.tags
}
