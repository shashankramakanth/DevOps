// TODO: add additional security resources for this module as needed

resource "aws_security_group" "alb" {
    name        = "${var.aws_project}-${var.aws_environment}-alb-sg"
    description = "Security group for ALB in ${var.aws_project}-${var.aws_environment}"
    vpc_id      = var.vpc_id

    dynamic "ingress" {
        for_each = var.alb_ingress_ports
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    # Allow all outbound traffic
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-alb-sg"
    }
}

resource "aws_security_group" "compute" {
    name        = "${var.aws_project}-${var.aws_environment}-compute-sg"
    description = "Security group for compute resources that only accepts traffic from the ALB"
    vpc_id      = var.vpc_id

    # Allow all traffic, but only from the ALB security group
    ingress {
        description     = "Allow traffic from the ALB"
        from_port       = 8080
        to_port         = 8080
        protocol        = "tcp"
        security_groups = [aws_security_group.alb.id]
    }

    # Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-compute-sg"
    }
}

