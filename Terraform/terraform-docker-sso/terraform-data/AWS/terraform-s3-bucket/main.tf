terraform {
    required_version = ">= 1.0"
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
        }
    }
}

provider "aws" {
  region = var.aws_region
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper = false
  lower = true
}

resource "aws_s3_bucket" "bucket1" {
  depends_on = [ random_string.bucket_suffix ]
  bucket = "${var.bucket_name}-${random_string.bucket_suffix.result}"
  force_destroy = false

  tags = {
    Name        = "my-terraform-bucket-unique101"
    Environment = "Dev"
    CreatedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket1.id
  versioning_configuration {
    status = "Enabled"
  }
  
}