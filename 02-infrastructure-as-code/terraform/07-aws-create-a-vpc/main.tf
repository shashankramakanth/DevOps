resource "aws_vpc" "xfusion_vpc"{
    cidr_block = "10.0.0.0/16"
    # It instructs AWS to automatically assign a /56 IPv6 CIDR block from its pool.
    assign_generated_ipv6_cidr_block = true
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "xfusion-vpc"
    }
}