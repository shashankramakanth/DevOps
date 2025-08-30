resource "aws_eip" "elastic_ip01" {
  domain = "vpc"
  tags = {
    Name = "xfusion-ec2-elastic-ip"
  }
  
}