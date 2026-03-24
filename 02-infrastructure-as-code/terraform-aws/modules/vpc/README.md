# VPC Module

## Purpose

This module manages the core VPC networking for the environment, including the VPC itself, subnets, internet gateway, NAT gateway, and route tables.

## Inputs

- `vpc_cidr` – CIDR block for the VPC.
- `aws_project` – AWS project name.
- `aws_environment` – AWS environment (e.g. dev, stage, prod).
- `enable_nat_gateway` – Whether to create a NAT gateway for private subnets.
- `subnets` – Map of subnet definitions (CIDR, availability zone, and whether to map public IPs on launch).

## Outputs

- `vpc_id` – ID of the VPC.
- `vpc_cidr` – CIDR block of the VPC.
- `public_subnet_ids` – List of public subnet IDs.
- `private_subnet_ids` – List of private subnet IDs.
- `nat_gateway_id` – ID of the NAT gateway.
- `public_route_table_id` – ID of the public route table.
- `private_route_table_id` – ID of the private route table.

## Relationships

Other modules such as ALB, compute, and security are expected to consume these outputs (for example, subnet IDs and VPC ID) to attach their resources into this VPC.

