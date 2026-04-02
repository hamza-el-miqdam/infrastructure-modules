# AWS IAM OIDC Module

This generic Terraform module provisions AWS OpenID Connect (OIDC) identity providers and creates strictly scoped AWS IAM roles that can be assumed by external platforms (like GitHub Actions and GitLab CI).

By leveraging OIDC, you eliminate the need for long-lived, static AWS credentials, mitigating the risk of leaked access keys while strictly adhering to the principle of least privilege.

## Features

- Conditionally create the AWS IAM OIDC provider.
- Retrieve the provider ARN if it already exists.
- Create an IAM role with a strict trust relationship (`sts:AssumeRoleWithWebIdentity`).
- Scopes the role assumption automatically to specific claims:
  - Match specific audiences via the `aud` claim (e.g., `sts.amazonaws.com`).
  - Restrict access to specific subjects via the `sub` claim (e.g., repositories and branches).
- Attach custom IAM policies to the role.

## Usage Examples

### GitHub Actions

This example demonstrates how to set up an OIDC role for a specific GitHub repository so its workflows can assume an AWS IAM role.

```hcl
module "github_actions_oidc" {
  source = "./terraform_modules/aws/iam_oidc"

  create_provider   = true
  oidc_provider_url = "token.actions.githubusercontent.com"
  client_id_list    = ["sts.amazonaws.com"]

  role_name        = "github-actions-deploy-role"
  role_description = "Role for GitHub Actions to deploy infrastructure"

  # Ensure least privilege by strictly scoping subjects (StringLike is used under the hood)
  subjects = [
    "repo:my-org/my-repo:ref:refs/heads/main",
    "repo:my-org/my-repo:pull_request"
  ]

  # Policies to attach to the role
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess" # Example, prefer least privilege
  ]
}
```

### GitLab CI

This example configures an OIDC trust for GitLab CI. Note that GitLab uses a different subject claim format than GitHub.

```hcl
module "gitlab_ci_oidc" {
  source = "./terraform_modules/aws/iam_oidc"

  create_provider   = true
  oidc_provider_url = "gitlab.com"
  client_id_list    = ["https://gitlab.com"] # GitLab's audience defaults to its URL

  role_name        = "gitlab-ci-deploy-role"
  role_description = "Role for GitLab CI runners"

  # Scoping subjects to a specific GitLab project and branch
  subjects = [
    "project_path:my-group/my-project:ref_type:branch:ref:main"
  ]

  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}
```
