output "vpc_id" {
    description = "ID of the VPC"
    value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
    description = "List of public subnet IDs"
    value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
    description = "List of private subnet IDs"
    value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
    description = "ID of the NAT gateway"
    value       = module.vpc.nat_gateway_id
}

output "public_route_table_id" {
    description = "ID of the public route table"
    value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
    description = "ID of the private route table"
    value       = module.vpc.private_route_table_id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.compute.compute_resource_ids
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.compute.app_private_ip
}
