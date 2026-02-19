# Enable Security Hub on the account
resource "aws_securityhub_account" "this" {
  enable_default_standards = false
  region                   = var.region
}

# Add CIS AWS Foundations standard
resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.4.0"
}

# Add best practices standard
resource "aws_securityhub_standards_subscription" "aws_best_practices" {
  standards_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
}
