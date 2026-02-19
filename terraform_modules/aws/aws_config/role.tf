# IAM Role and Policies for AWS Config
data "aws_iam_policy_document" "config_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "config_role" {
  name               = "${var.recorder_name}-role"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role.json
  tags               = var.tags
}

# Attach the AWS managed policy for Config
resource "aws_iam_role_policy_attachment" "config_managed_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# Custom policy to allow Config to write to the specified S3 bucket
data "aws_iam_policy_document" "config_s3_policy" {
  statement {
    sid     = "AllowConfigS3Access"
    effect  = "Allow"
    actions = ["s3:PutObject", "s3:GetBucketAcl"]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/AWSLogs/*"
    ]
    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_iam_role_policy" "config_s3_policy" {
  name   = "${var.recorder_name}-s3-policy"
  role   = aws_iam_role.config_role.id
  policy = data.aws_iam_policy_document.config_s3_policy.json
}
