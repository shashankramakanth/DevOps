output "vpc_id" {
    description = "ID of the VPC"
    value       = aws_vpc.this.id
}

output "vpc_cidr" {
    description = "CIDR block of the VPC"
    value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
    description = "List of public subnet IDs"
    value       = [for k, v in aws_subnet.this : v.id if v.map_public_ip_on_launch]
}

output "private_subnet_ids" {
    description = "List of private subnet IDs"
    value       = [for k, v in aws_subnet.this : v.id if !v.map_public_ip_on_launch]
}

output "nat_gateway_id" {
    description = "ID of the NAT gateway"
    value       = aws_nat_gateway.this[0].id
}

output "public_route_table_id" {
    description = "ID of the public route table"
    value       = aws_route_table.public.id
}

output "private_route_table_id" {
    description = "ID of the private route table"
    value       = aws_route_table.private[0].id
}