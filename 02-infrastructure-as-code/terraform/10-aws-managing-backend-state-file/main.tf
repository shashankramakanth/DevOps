resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
  lower   = true
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "my-unique-demo-bucket-${random_string.storage_suffix.result}"  # must be globally unique
}

