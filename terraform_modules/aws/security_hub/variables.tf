variable "region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
