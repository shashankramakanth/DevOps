// TODO: add compute resources for this module

resource "aws_instance" "app" {
    ami           = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.security_group_id]
    subnet_id = var.subnet_ids[0]
    user_data = base64encode(var.user_data)

    associate_public_ip_address = false

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-app"
    }

    lifecycle {
        create_before_destroy = true
    }
}

