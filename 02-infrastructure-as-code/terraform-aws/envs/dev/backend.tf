terraform {
  backend "s3" {
    bucket       = "terraform-aws-terraform-state-5d68f0e0"
    key          = "envs/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

