terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  runtime_secret_parameter_name = coalesce(var.secret_parameter_name, "/${var.aws_project}/global/runtime-secret")
}

resource "random_id" "suffix" {
  byte_length = 4
}

# S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.aws_project}-terraform-state-${random_id.suffix.hex}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Terraform State"
    Environment = "global"
    Project     = var.aws_project
  }
}

# Enable versioning for state history and rollback
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Block all public access to the state bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.aws_project}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Locks"
    Environment = "global"
    Project     = var.aws_project
  }
}

# KMS key for encrypting SSM runtime secret
resource "aws_kms_key" "ssm_secret" {
  count                   = var.create_runtime_secret ? 1 : 0
  description             = "KMS key for ${var.aws_project} runtime secret in SSM Parameter Store"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name        = "${var.aws_project}-ssm-secret-kms"
    Environment = "global"
    Project     = var.aws_project
  }
}

resource "aws_kms_alias" "ssm_secret" {
  count         = var.create_runtime_secret ? 1 : 0
  name          = "alias/${var.aws_project}-ssm-secret"
  target_key_id = aws_kms_key.ssm_secret[0].key_id
}

# SecureString parameter for runtime secret consumption
resource "aws_ssm_parameter" "runtime_secret" {
  count  = var.create_runtime_secret ? 1 : 0
  name   = local.runtime_secret_parameter_name
  type   = "SecureString"
  value  = var.secret_value
  key_id = aws_kms_key.ssm_secret[0].arn

  tags = {
    Name        = "${var.aws_project}-runtime-secret"
    Environment = "global"
    Project     = var.aws_project
  }
}

data "aws_iam_policy_document" "ssm_secret_read" {
  count = var.create_runtime_secret ? 1 : 0

  statement {
    sid       = "ReadRuntimeSecretParameter"
    actions   = ["ssm:GetParameter"]
    resources = [aws_ssm_parameter.runtime_secret[0].arn]
  }

  statement {
    sid       = "DecryptRuntimeSecretKey"
    actions   = ["kms:Decrypt"]
    resources = [aws_kms_key.ssm_secret[0].arn]
  }
}

resource "aws_iam_policy" "ssm_secret_read" {
  count       = var.create_runtime_secret ? 1 : 0
  name        = "${var.aws_project}-ssm-runtime-secret-read"
  description = "Read/decrypt access for ${local.runtime_secret_parameter_name}"
  policy      = data.aws_iam_policy_document.ssm_secret_read[0].json
}

resource "aws_iam_role_policy_attachment" "runtime_secret_reader" {
  count      = var.create_runtime_secret && var.runtime_role_name != null ? 1 : 0
  role       = var.runtime_role_name
  policy_arn = aws_iam_policy.ssm_secret_read[0].arn
}
