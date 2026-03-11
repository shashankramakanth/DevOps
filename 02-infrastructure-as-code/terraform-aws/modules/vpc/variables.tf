variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "aws_project" {
    description = "AWS project"
    type        = string
}

variable "aws_environment" {
    description = "AWS environment"
    type        = string

    validation {
        condition = contains(["dev", "stage", "prod"], var.aws_environment)
        error_message = "AWS environment must be dev, stage, or prod"
    }
}

variable "enable_nat_gateway" {
    description = "Enable NAT gateway"
    type        = bool
    default     = true
}

variable "subnets" {
    description = "map of subnets"
    type        = map(object({
        cidr_block = string
        availability_zone = string
        map_public_ip_on_launch = bool
    }))
}
