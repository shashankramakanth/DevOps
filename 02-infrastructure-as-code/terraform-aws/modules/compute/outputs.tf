output "compute_resource_ids" {
  description = "IDs of compute resources (e.g. EC2 instances or ASG)"
  value = aws_instance.app.id
}

output "app_private_ip" {
  description = "Private IP address of the app"
  value = aws_instance.app.private_ip
}

