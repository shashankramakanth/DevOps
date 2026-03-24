variable "aws_project" {
  description = "AWS project name"
  type        = string
}

variable "aws_environment" {
  description = "AWS environment (e.g. dev, stage, prod)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where compute resources will be created"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type for compute resources (e.g. EC2 or ASG launch template)"
  type        = string
}

variable "security_group_id" {
  description = "security group ID to attach to the compute resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the compute resources"
  type        = string
}

variable "user_data" {
  description = "Base64 encoded user data to pass to the compute resources"
  type        = string
}