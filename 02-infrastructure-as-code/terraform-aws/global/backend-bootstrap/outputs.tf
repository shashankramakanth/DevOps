output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_locks.arn
}

output "runtime_secret_parameter_name" {
  description = "Name of the SSM runtime secret parameter (null when create_runtime_secret is false)"
  value       = var.create_runtime_secret ? aws_ssm_parameter.runtime_secret[0].name : null
}

output "runtime_secret_parameter_arn" {
  description = "ARN of the SSM runtime secret parameter (null when create_runtime_secret is false)"
  value       = var.create_runtime_secret ? aws_ssm_parameter.runtime_secret[0].arn : null
}

output "runtime_secret_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the runtime secret (null when create_runtime_secret is false)"
  value       = var.create_runtime_secret ? aws_kms_key.ssm_secret[0].arn : null
}

output "runtime_secret_read_policy_arn" {
  description = "ARN of the generated IAM policy for reading/decrypting the runtime secret (null when create_runtime_secret is false)"
  value       = var.create_runtime_secret ? aws_iam_policy.ssm_secret_read[0].arn : null
}
