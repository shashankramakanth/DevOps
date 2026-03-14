resource "random_id" "suffix" {
  byte_length = 8
}

locals {
  bucket_name = "${var.aws_project}-${var.aws_environment}-bucket-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "bucket01" {
  bucket = local.bucket_name
}

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

