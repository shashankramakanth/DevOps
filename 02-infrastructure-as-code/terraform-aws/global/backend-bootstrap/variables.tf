variable "aws_region" {
  description = "AWS region for the backend resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_project" {
  description = "Project name used in resource naming"
  type        = string
  default     = "terraform-aws"
}
