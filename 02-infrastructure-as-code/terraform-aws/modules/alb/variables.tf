variable "aws_project" {
  description = "AWS project name"
  type        = string
}

variable "aws_environment" {
  description = "AWS environment (e.g. dev, stage, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to attach to the ALB"
  type        = list(string)
}

