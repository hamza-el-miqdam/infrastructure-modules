variable "recorder_name" {
  description = "The name of the configuration recorder."
  type        = string
  default     = "default-recorder"
}

variable "delivery_channel_name" {
  description = "The name of the delivery channel."
  type        = string
  default     = "default-delivery-channel"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store AWS Config logs. (Bucket must exist)"
  type        = string
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic to which AWS Config sends notifications. (Optional)"
  type        = string
  default     = null
}

variable "include_global_resource_types" {
  description = "Specifies whether AWS Config includes all supported types of global resources (e.g., IAM resources) with the resources that it records."
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "Whether the configuration recorder should be enabled or disabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
