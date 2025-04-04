provider "aws" {
  region = var.aws_region
}

provider "local" {}

# Create S3 bucket
resource "aws_s3_bucket" "static_site" {
  bucket        = var.bucket_name
  force_destroy = true
}

# Set website hosting configuration
resource "aws_s3_bucket_website_configuration" "static_site_website" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Allows the bucket to have a public read policy applied
resource "aws_s3_bucket_public_access_block" "allow_public_policy" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# Public read access bucket policy
resource "aws_s3_bucket_policy" "public_read" {
  depends_on = [aws_s3_bucket_public_access_block.allow_public_policy]  # important
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}

# Load CORS settings from s3-cors.json
data "local_file" "cors_config" {
  filename = "${path.module}/s3-cors.json"
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.static_site.id

  dynamic "cors_rule" {
    for_each = jsondecode(data.local_file.cors_config.content)
    content {
      allowed_headers = cors_rule.value.AllowedHeaders
      allowed_methods = cors_rule.value.AllowedMethods
      allowed_origins = cors_rule.value.AllowedOrigins
      expose_headers  = try(cors_rule.value.ExposeHeaders, [])
      max_age_seconds = try(cors_rule.value.MaxAgeSeconds, null)
    }
  }
}

# IAM user for deploying site
resource "aws_iam_user" "deployer" {
  name = var.iam_user_name
}

# IAM user policy to allow access to the bucket
resource "aws_iam_user_policy" "s3_access" {
  name = "S3DeployPolicy"
  user = aws_iam_user.deployer.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.static_site.arn,
          "${aws_s3_bucket.static_site.arn}/*"
        ]
      }
    ]
  })
}

# IAM access key (used in GitHub Actions or other CI/CD)
resource "aws_iam_access_key" "deployer_key" {
  user = aws_iam_user.deployer.name
}
