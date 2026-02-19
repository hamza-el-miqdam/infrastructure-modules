output "recorder_id" {
  description = "The ID of the AWS Config Recorder"
  value       = aws_config_configuration_recorder.main.id
}

output "iam_role_arn" {
  description = "The ARN of the IAM Role created for AWS Config"
  value       = aws_iam_role.config_role.arn
}
