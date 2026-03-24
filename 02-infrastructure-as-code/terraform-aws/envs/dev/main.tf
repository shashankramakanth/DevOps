module "vpc" {
    source = "../../modules/vpc"
    vpc_cidr = "10.0.0.0/16"
    enable_nat_gateway = true
    aws_project     = var.aws_project
    aws_environment = var.aws_environment
    subnets = {
        public_subnet_1 = {
            cidr_block = "10.0.1.0/24"
            availability_zone = "us-east-1a"
            map_public_ip_on_launch = true
        }
        public_subnet_2 = {
            cidr_block = "10.0.2.0/24"
            availability_zone = "us-east-1b"
            map_public_ip_on_launch = true
        }
        private_subnet_1 = {
            cidr_block = "10.0.3.0/24"
            availability_zone = "us-east-1a"
            map_public_ip_on_launch = false
        }
        private_subnet_2 = {
            cidr_block = "10.0.4.0/24"
            availability_zone = "us-east-1b"
            map_public_ip_on_launch = false
        }
    }

}

module "security" {
    source = "../../modules/security"
    aws_project = var.aws_project
    aws_environment = var.aws_environment
    vpc_id = module.vpc.vpc_id
}

# Look up latest Amazon Linux 2 AMI — never hardcode AMI IDs
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "compute" {
  source          = "../../modules/compute"
  aws_project     = var.aws_project
  aws_environment = var.aws_environment
  subnet_ids      = module.vpc.private_subnet_ids
  security_group_id = module.security.security_group_compute_ids
  instance_type   = "t3.micro"
  ami_id          = data.aws_ami.amazon_linux.id
  user_data       = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
    systemctl start httpd
    systemctl enable httpd
    mkdir -p /var/www/html
    echo "OK" > /var/www/html/health
    echo "<h1>$(hostname -f)</h1>" > /var/www/html/index.html
  EOF
}
