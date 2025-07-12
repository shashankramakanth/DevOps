variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (will have random suffix appended)"
  type        = string
  default     = "my-terraform-bucket"
}
