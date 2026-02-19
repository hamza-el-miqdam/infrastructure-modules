# AWS Config Recorder
resource "aws_config_configuration_recorder" "main" {
  name     = var.recorder_name
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = var.include_global_resource_types
  }
}

# AWS Config Delivery Channel
resource "aws_config_delivery_channel" "main" {
  name           = var.delivery_channel_name
  s3_bucket_name = var.s3_bucket_name
  sns_topic_arn  = var.sns_topic_arn

  depends_on = [aws_config_configuration_recorder.main]
}

# Enable the recorder
resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = var.is_enabled

  depends_on = [aws_config_delivery_channel.main]
}
