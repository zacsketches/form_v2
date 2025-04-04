# Outputs the S3 website endpoint using the new resource
output "s3_bucket_website_url" {
  description = "The public website URL of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.static_site_website.website_endpoint
}

# IAM Access Key ID (non-sensitive)
output "iam_access_key_id" {
  description = "Access Key ID for the deployer IAM user"
  value       = aws_iam_access_key.deployer_key.id
}

# IAM Secret Access Key (sensitive)
output "iam_secret_access_key" {
  description = "Secret Access Key for the deployer IAM user"
  value       = aws_iam_access_key.deployer_key.secret
  sensitive   = true
}
output "store_secret_now" {
  value     = "⚠️ Store the secret key now — you won't see it again!"
  sensitive = false
}