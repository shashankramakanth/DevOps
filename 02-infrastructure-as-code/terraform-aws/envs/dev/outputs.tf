output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.bucket01.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.bucket01.arn
}

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
