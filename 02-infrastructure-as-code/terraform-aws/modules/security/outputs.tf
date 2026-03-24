output "security_group_alb_ids" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "security_group_compute_ids" {
  description = "ID of the compute security group"
  value       = aws_security_group.compute.id
}