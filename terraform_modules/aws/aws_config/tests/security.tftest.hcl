# Security tests for AWS Config IAM role and S3 policy

mock_resource "aws_config_configuration_recorder" "main" {
  defaults = {
    name     = "test-recorder"
    role_arn = "arn:aws:iam::123456789012:role/test-recorder-role"
  }
}

mock_resource "aws_config_delivery_channel" "main" {
  defaults = {
    name           = "test-delivery-channel"
    s3_bucket_name = "test-bucket"
  }
}

mock_data "aws_caller_identity" "current" {
  defaults = {
    account_id = "123456789012"
    arn        = "arn:aws:iam::123456789012:user/test"
    user_id    = "test-user-id"
  }
}

variables {
  s3_bucket_name = "test-bucket"
  recorder_name  = "test-recorder"
}

run "verify_iam_role_trust_policy" {
  command = plan

  assert {
    condition     = contains(jsondecode(aws_iam_role.config_role.assume_role_policy).Statement[0].Condition.StringEquals["aws:SourceAccount"], "123456789012")
    error_message = "IAM role trust policy missing aws:SourceAccount condition"
  }
}

run "verify_s3_policy_restrictions" {
  command = plan

  assert {
    condition     = jsondecode(aws_iam_role_policy.config_s3_policy.policy).Statement[0].Action == "s3:GetBucketAcl" && jsondecode(aws_iam_role_policy.config_s3_policy.policy).Statement[0].Resource == "arn:aws:s3:::test-bucket"
    error_message = "S3 GetBucketAcl should be restricted to the bucket ARN"
  }

  assert {
    condition     = jsondecode(aws_iam_role_policy.config_s3_policy.policy).Statement[1].Action == "s3:PutObject" && jsondecode(aws_iam_role_policy.config_s3_policy.policy).Statement[1].Resource == "arn:aws:s3:::test-bucket/AWSLogs/*"
    error_message = "S3 PutObject should be restricted to the AWSLogs/* prefix"
  }
}
