output "role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.this.name
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider (either created or referenced)."
  value       = local.provider_arn
}
