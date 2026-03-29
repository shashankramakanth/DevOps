// TODO: add compute resources for this module
# checkov:skip=CKV_AWS_23:Description added to ingress rule
# checkov:skip=CKV_AWS_382:Unrestricted egress intentional for outbound updates
# checkov:skip=CKV2_AWS_5:Attached to EC2 instance via compute module
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_ids[0]
  user_data              = var.user_data

  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${var.aws_project}-${var.aws_environment}-app"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}

