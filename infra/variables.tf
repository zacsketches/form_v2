variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "iam_user_name" {
  default = "s3-dev-deployer"
}
