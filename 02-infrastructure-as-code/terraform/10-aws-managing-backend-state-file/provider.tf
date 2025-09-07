terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = "aws-112940-s3-bucket"   # replace with your actual bucket name
    key            = "terraform/terraform.tfstate"      # path within the bucket
    region         = "us-east-1"                        # AWS region of the bucket
    encrypt        = true                               # enable server-side encryption
    dynamodb_table = "terraform-state-lock"                    # replace with your DynamoDB table name for state locking
    profile        = "default"                          # AWS CLI profile to use
   # endpoint       = ""                                 # optional: custom endpoint, e.g., for local testing
  }
}

provider "aws" {
  region = "us-east-1"
}
