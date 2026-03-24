terraform {
  backend "s3" {
    bucket         = "terraform-aws-terraform-state-0f8149cd"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile =  true
    encrypt        = true
  }
}

