provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.aws_environment
      Project     = var.aws_project
    }
  }
}

