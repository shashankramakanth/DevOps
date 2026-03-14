terraform {
  backend "s3" {
    bucket         = "terraform-aws-terraform-state-792b6224"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-aws-terraform-locks"
    encrypt        = true
  }
}

