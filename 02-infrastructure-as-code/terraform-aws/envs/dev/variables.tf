variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_environment" {
  description = "AWS environment"
  type        = string
  default     = "dev"
  
  validation {
    condition = contains(["dev", "stage", "prod"], var.aws_environment)
    error_message = "AWS environment must be dev, stage, or prod"
  }
}

variable "aws_project" {
  description = "AWS project"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "allowed_environments" {
  description = "List of allowed environments"
  type        = set(string)
  default     = ["dev", "stage", "prod"]

  validation {
    condition = contains(var.allowed_environments, var.aws_environment)
    error_message = "AWS environment must be dev, stage, or prod"
  }
}

variable "instance_types" {
  description = "List of instance types"
  type        = map(string)
  default     = {
    dev = "t3.micro"
    stage = "t3.small"
    prod = "t3.small"
  }
}