resource "random_id" "suffix" {
  byte_length = 8
}

locals {
  bucket_name = "${var.aws_project}-${var.aws_environment}-bucket-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "bucket01" {
  bucket = local.bucket_name
}
