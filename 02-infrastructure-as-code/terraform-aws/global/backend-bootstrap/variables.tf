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

variable "create_runtime_secret" {
  description = "Whether to create an SSM SecureString parameter for runtime secret storage"
  type        = bool
  default     = false
}

variable "secret_parameter_name" {
  description = "SSM parameter name for the runtime secret. If null, a default path based on project name is used."
  type        = string
  default     = null
  nullable    = true
}

variable "secret_value" {
  description = "Secret value to store in SSM Parameter Store when create_runtime_secret is true"
  type        = string
  default     = null
  nullable    = true
  sensitive   = true

  validation {
    condition     = var.create_runtime_secret ? var.secret_value != null && trimspace(var.secret_value) != "" : true
    error_message = "secret_value must be set and non-empty when create_runtime_secret is true."
  }
}

variable "runtime_role_name" {
  description = "Optional IAM role name to attach the generated secret read policy to"
  type        = string
  default     = null
  nullable    = true
}
