variable "aws_project" {
  description = "AWS project name"
  type        = string
}

variable "aws_environment" {
  description = "AWS environment (e.g. dev, stage, prod)"
  type        = string
}


variable "alb_ingress_ports" {
  description = "List of TCP ports to open on the ALB security group"
  type        = list(number)
  default     = [80, 443]
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "egress_rules"{
  description = "List of egress rules to apply to the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default     = [ {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }]
}